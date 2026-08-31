#!/usr/bin/env python3
"""
Generate a topology-aware traffic-spline network, importable into GIANTS
Editor, from the real primary/secondary road centerlines cached at
tools/pda/sources/ingame_roads.json.

Pipeline:
  1. Detect junctions between the 13 named road pieces: true interior
     crossings (segment-segment intersection) plus T-junctions (a road's
     endpoint landing within CLOSE_TOL of another road -- own endpoint or
     interior point). Nearby hits are clustered into single junction nodes.
  2. Split each road into intersection-to-intersection sub-segments at its
     junction params.
  3. For each sub-segment, generate two offset lane curves +/-LANE_OFFSET_M
     from centerline:
       - laneB: forward point order (sub-segment start->end), offset to the
         right-hand side of that direction of travel.
       - laneA: REVERSED point order (end->start), offset to the right-hand
         side of THAT (reverse) direction -- i.e. opposite physical side of
         the road from laneB. This is what makes each lane's own control-
         point order encode the correct US right-hand-traffic direction,
         not just an arbitrary offset side.
  4. At every junction, connect each incoming lane (arrives there) to every
     outgoing lane from a DIFFERENT sub-segment (skips the same sub-segment's
     paired lane, which would be a same-spot U-turn) with a tangent-matched
     quadratic Bezier fillet. This covers through movements and turns
     without needing to classify turn legality -- N legs -> N(N-1) movements.
  5. Assembles everything into one `trafficSystem` TransformGroup with a
     UserAttribute wiring it to map/config/trafficSystem.xml, plus per-curve
     speedLimit/maxSpeedScale/vehicleTypes UserAttributes (50 primary / 35
     secondary through-lanes, 12 at junction connectors -- matching the old
     MapToPlay data's convention).

Curve fidelity: control points come from Ramer-Douglas-Peucker simplification
of the dense (up to 800-point) real centerlines at RDP_TOL=0.3m, not a coarse
approximation -- tight enough to preserve gentle/subtle road curvature, not
just corners. (An earlier pass used 2.0m tolerance, which was flattening long
roads to 2-3 points and losing real curves -- fixed.)

Elevation: each control point's Y is sampled directly from the terrain
heightmap (map/data/dem.png, bilinear-interpolated) using the map's real
heightScale=255 (from map.i3d's TerrainTransformGroup), plus a small
SPLINE_CLEARANCE_M lift to avoid z-fighting with the ground. Curves are
terrain-following on generation, not placeholder-flat.

Manual links: MANUAL_BRIDGE_LINKS lists road-endpoint pairs that are
physically continuous but too far apart for the automatic proximity pass to
find (e.g. a bridge whose deck isn't texture-painted, so it never showed up
in the road-centerline export). Unlike auto-detected junctions, a manual
link does NOT create a junction node or merge into an existing one -- it
directly wires exactly 2 connector curves (laneB->laneB, laneA->laneA)
between the two named lane curves, using whichever sub-segment already owns
that road's specified end. This matters when one side is already part of a
real junction (e.g. a bridge continuing on from a road that also T's into
another road at that same point): merging would have added the bridge as a
new leg of that junction and exploded it into full N-way turn combinatorics
(every leg connecting to every other leg, including movements that were
never intended, like traffic from an unrelated leg cutting straight onto the
bridge). The direct link keeps the existing junction's own connectors
untouched and adds just the 2 movements that were actually asked for. Height
along a manual-link connector is linearly interpolated between the two
endpoint heights rather than sampled from the terrain underneath -- other-
wise a bridge connector would dip down to the riverbed/water level it's
crossing over (same BRIDGE_SPAN_M distance check used for any connector).

This does NOT cover grassTrack01/driveWay01 (not in the cached centerline
data -- re-export their CSVs in GE and re-run build_ingame_roads.py first
if you want those included), and flags a handful of road endpoints that
don't reach any other named road or the map edge -- those need a human call,
not an auto-generated bridge.

Usage:
  python3 build_traffic_network.py [mod_root] [out_i3d]
"""
import sys, os, json, math
from PIL import Image
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
LANE_OFFSET_M = 1.5
HEIGHT_SCALE = 255.0  # from map.i3d TerrainTransformGroup heightScale attribute
SPLINE_CLEARANCE_M = 0.2  # small lift above bare terrain height to avoid z-fighting
RDP_TOL = 0.3
CLOSE_TOL = 10.0
MAX_HANDLE_DIST = 200.0
MAP_EDGE = 2040.0  # world coords beyond this are the playable-area boundary
BRIDGE_SPAN_M = 25.0  # any connector longer than this is treated as a bridge
                       # deck: straight line + height interpolated between its
                       # two true endpoints, not sampled from the terrain
                       # underneath (real junction fillets are all <6m in this
                       # network, so this cleanly separates the two cases)

# Manually-confirmed links between road endpoints that the automatic proximity
# pass (CLOSE_TOL=10m) can't find because there's real distance between them
# on the ground -- e.g. a bridge, where the road surface isn't texture-painted
# (so it never showed up in the road-centerline export) but the road is
# physically continuous. Each is wired as exactly 2 direct connector curves
# (see docstring above) -- NOT merged into any junction, even when one side
# already belongs to one. Height is interpolated across the gap rather than
# terrain-sampled (see BRIDGE_SPAN_M) since these all cross real low
# ground/water. Confirmed with the user:
#   2026-08-31: primaryRoad05 end <-> primaryRoad06 start (~117m, river)
#   2026-08-31: primaryRoad09 end <-> primaryRoad10 start (~41m, second river
#               crossing right next to the primaryRoad08/09 junction (J4) --
#               primaryRoad09's end stays a normal J4 member for its real
#               08/09 connectors; this link separately/additionally connects
#               its lanes straight across to primaryRoad10, without adding
#               primaryRoad10 as a 4th leg of J4)
MANUAL_BRIDGE_LINKS = [
    ("primaryRoad05", "end", "primaryRoad06", "start"),
    ("primaryRoad09", "end", "primaryRoad10", "start"),
]


def dist(a, b):
    return math.hypot(a[0] - b[0], a[1] - b[1])


def point_at_param(poly, param):
    i = max(0, min(len(poly) - 2, int(math.floor(param))))
    t = param - i
    x1, z1 = poly[i]; x2, z2 = poly[i + 1]
    return (x1 + t * (x2 - x1), z1 + t * (z2 - z1))


def seg_intersect(p1, p2, p3, p4):
    x1, z1 = p1; x2, z2 = p2; x3, z3 = p3; x4, z4 = p4
    d = (x2 - x1) * (z4 - z3) - (z2 - z1) * (x4 - x3)
    if abs(d) < 1e-12:
        return None
    t = ((x3 - x1) * (z4 - z3) - (z3 - z1) * (x4 - x3)) / d
    u = ((x3 - x1) * (z2 - z1) - (z3 - z1) * (x2 - x1)) / d
    if -1e-9 <= t <= 1 + 1e-9 and -1e-9 <= u <= 1 + 1e-9:
        return (x1 + t * (x2 - x1), z1 + t * (z2 - z1), t, u)
    return None


def bbox_overlap(a1, a2, b1, b2, pad=0.5):
    ax0, ax1 = sorted([a1[0], a2[0]]); az0, az1 = sorted([a1[1], a2[1]])
    bx0, bx1 = sorted([b1[0], b2[0]]); bz0, bz1 = sorted([b1[1], b2[1]])
    return not (ax1 + pad < bx0 or bx1 + pad < ax0 or az1 + pad < bz0 or bz1 + pad < az0)


def closest_point_on_polyline(pt, poly):
    best_d, best_loc = float("inf"), None
    for i in range(len(poly) - 1):
        x1, z1 = poly[i]; x2, z2 = poly[i + 1]
        dx, dz = x2 - x1, z2 - z1
        L2 = dx * dx + dz * dz
        t = 0 if L2 == 0 else max(0, min(1, ((pt[0] - x1) * dx + (pt[1] - z1) * dz) / L2))
        px, pz = x1 + t * dx, z1 + t * dz
        d = dist(pt, (px, pz))
        if d < best_d:
            best_d, best_loc = d, (i + t, px, pz)
    return best_d, best_loc


def rdp(points, tol):
    if len(points) < 3:
        return points
    (x1, z1), (x2, z2) = points[0], points[-1]
    dx, dz = x2 - x1, z2 - z1
    seg_len = math.hypot(dx, dz)
    max_dist, max_idx = -1.0, -1
    for i in range(1, len(points) - 1):
        x0, z0 = points[i]
        dd = math.hypot(x0 - x1, z0 - z1) if seg_len == 0 else abs(dz * x0 - dx * z0 + x2 * z1 - z2 * x1) / seg_len
        if dd > max_dist:
            max_dist, max_idx = dd, i
    if max_dist > tol:
        left = rdp(points[:max_idx + 1], tol)
        right = rdp(points[max_idx:], tol)
        return left[:-1] + right
    return [points[0], points[-1]]


def pad_to_min_points(pts, min_n=4):
    pts = list(pts)
    while len(pts) < min_n:
        best_i, best_len = 0, -1.0
        for i in range(len(pts) - 1):
            L = dist(pts[i], pts[i + 1])
            if L > best_len:
                best_len, best_i = L, i
        mx = (pts[best_i][0] + pts[best_i + 1][0]) / 2
        mz = (pts[best_i][1] + pts[best_i + 1][1]) / 2
        pts.insert(best_i + 1, (mx, mz))
    return pts


def offset_points(points, offset):
    n = len(points)
    out = []
    for i in range(n):
        if i == 0:
            tx, tz = points[1][0] - points[0][0], points[1][1] - points[0][1]
        elif i == n - 1:
            tx, tz = points[-1][0] - points[-2][0], points[-1][1] - points[-2][1]
        else:
            tx, tz = points[i + 1][0] - points[i - 1][0], points[i + 1][1] - points[i - 1][1]
        length = math.hypot(tx, tz)
        nx, nz = (0.0, 0.0) if length == 0 else (-tz / length, tx / length)
        x, z = points[i]
        out.append((x + nx * offset, z + nz * offset))
    return out


def norm(v):
    L = math.hypot(*v)
    return (0.0, 0.0) if L == 0 else (v[0] / L, v[1] / L)


def line_intersect_point(p0, d0, p2, d2):
    x1, z1 = p0; x2, z2 = (p0[0] + d0[0], p0[1] + d0[1])
    x3, z3 = p2; x4, z4 = (p2[0] - d2[0], p2[1] - d2[1])
    denom = (x1 - x2) * (z3 - z4) - (z1 - z2) * (x3 - x4)
    if abs(denom) < 1e-9:
        return None
    t = ((x1 - x3) * (z3 - z4) - (z1 - z3) * (x3 - x4)) / denom
    return (x1 + t * (x2 - x1), z1 + t * (z2 - z1))


def bezier_sample(p0, p1, p2, n=5):
    out = []
    for i in range(n):
        t = i / (n - 1)
        x = (1 - t) ** 2 * p0[0] + 2 * (1 - t) * t * p1[0] + t ** 2 * p2[0]
        z = (1 - t) ** 2 * p0[1] + 2 * (1 - t) * t * p1[1] + t ** 2 * p2[1]
        out.append((x, z))
    return out


def load_dem_sampler(mod_root):
    dem_path = os.path.join(mod_root, "map", "data", "dem.png")
    dem = np.array(Image.open(dem_path)).astype(np.float64)
    h, w = dem.shape

    def sample(x, z):
        # world -> pixel (pixel = world + 2048), bilinear interpolation
        px = min(max(x + 2048.0, 0.0), w - 1.0001)
        pz = min(max(z + 2048.0, 0.0), h - 1.0001)
        x0, z0 = int(px), int(pz)
        x1, z1 = x0 + 1, z0 + 1
        fx, fz = px - x0, pz - z0
        v00, v10 = dem[z0, x0], dem[z0, x1]
        v01, v11 = dem[z1, x0], dem[z1, x1]
        v = (v00 * (1 - fx) * (1 - fz) + v10 * fx * (1 - fz)
             + v01 * (1 - fx) * fz + v11 * fx * fz)
        return v / 65535.0 * HEIGHT_SCALE

    return sample


def main():
    mod_root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "..", "..")
    out_path = sys.argv[2] if len(sys.argv) > 2 else os.path.join(HERE, "manvel_traffic_import.i3d")
    roads_json = os.path.join(mod_root, "tools", "pda", "sources", "ingame_roads.json")
    sample_height = load_dem_sampler(mod_root)

    with open(roads_json) as f:
        roads_raw = json.load(f)
    roads = {}
    for cls in ("primary", "secondary"):
        for seg in roads_raw[cls]:
            roads[seg["name"]] = [tuple(p) for p in seg["pts"]]
    names = list(roads.keys())
    bridge_traces = {seg["name"]: [tuple(p) for p in seg["pts"]] for seg in roads_raw.get("bridge", [])}

    # ---- 1. junction detection ----
    hits = []
    for i in range(len(names)):
        for j in range(i + 1, len(names)):
            na, nb = names[i], names[j]
            pa, pb = roads[na], roads[nb]
            for ia in range(len(pa) - 1):
                for ib in range(len(pb) - 1):
                    if not bbox_overlap(pa[ia], pa[ia + 1], pb[ib], pb[ib + 1]):
                        continue
                    r = seg_intersect(pa[ia], pa[ia + 1], pb[ib], pb[ib + 1])
                    if r:
                        ix, iz, t, u = r
                        hits.append([(na, ia + t, (ix, iz)), (nb, ib + u, (ix, iz))])
    for n in names:
        poly = roads[n]
        for param0, pt in ((0.0, poly[0]), (float(len(poly) - 1), poly[-1])):
            best = (float("inf"), None, None)
            for m in names:
                if m == n:
                    continue
                d, loc = closest_point_on_polyline(pt, roads[m])
                if d < best[0]:
                    best = (d, m, loc)
            d, m, loc = best
            if d < CLOSE_TOL:
                hits.append([(n, param0, pt), (m, loc[0], (loc[1], loc[2]))])

    class Junction:
        def __init__(self, jid, pos):
            self.id = jid; self.pos = pos; self.members = []
        def add(self, road, param):
            for r, p in self.members:
                if r == road and abs(p - param) < 3.0:
                    return
            self.members.append((road, param))

    junctions = []
    def find_or_create(pos):
        for j in junctions:
            if dist(j.pos, pos) < CLOSE_TOL:
                return j
        j = Junction(len(junctions), pos)
        junctions.append(j)
        return j

    # cluster all automatically-detected hits into junctions. Manual bridge
    # links (MANUAL_BRIDGE_LINKS) are intentionally NOT folded in here -- see
    # the docstring and the comment above MANUAL_BRIDGE_LINKS for why: they
    # get wired as direct point-to-point connectors later instead, so they
    # never turn an existing junction into a bigger N-way one.
    for (ra, pa, posa), (rb, pb, posb) in hits:
        j = find_or_create(((posa[0] + posb[0]) / 2, (posa[1] + posb[1]) / 2))
        j.add(ra, pa); j.add(rb, pb)

    print(f"junctions found: {len(junctions)}")
    for j in junctions:
        print(f"  J{j.id} @ ({j.pos[0]:.1f},{j.pos[1]:.1f}): {j.members}")

    matched = set()
    for j in junctions:
        for r, p in j.members:
            if abs(p) < 3.0:
                matched.add((r, "start"))
            if abs(p - (len(roads[r]) - 1)) < 3.0:
                matched.add((r, "end"))
    for roadA, endA, roadB, endB in MANUAL_BRIDGE_LINKS:
        matched.add((roadA, endA)); matched.add((roadB, endB))
    print("\nfree road endpoints (not auto-connected):")
    for n in names:
        poly = roads[n]
        for label, pt in (("start", poly[0]), ("end", poly[-1])):
            if (n, label) not in matched:
                edge = abs(pt[0]) > MAP_EDGE or abs(pt[1]) > MAP_EDGE
                tag = "map edge, expected" if edge else "** NOT near map edge -- needs manual check **"
                print(f"  {n} {label} @ ({pt[0]:.1f},{pt[1]:.1f})  [{tag}]")

    # ---- 2. split into sub-segments ----
    road_junction_params = {n: [] for n in names}
    for j in junctions:
        for r, p in j.members:
            road_junction_params[r].append((p, j.id))

    subsegments = []
    for n in names:
        poly = roads[n]
        pts_sorted = sorted(road_junction_params[n], key=lambda x: x[0])
        boundaries = []
        if not pts_sorted or pts_sorted[0][0] > 3.0:
            boundaries.append((0.0, None))
        boundaries.extend(pts_sorted)
        last_param = len(poly) - 1
        if not pts_sorted or pts_sorted[-1][0] < last_param - 3.0:
            boundaries.append((float(last_param), None))
        boundaries.sort(key=lambda x: x[0])
        seg_idx = 0
        for i in range(len(boundaries) - 1):
            p0, j0 = boundaries[i]; p1, j1 = boundaries[i + 1]
            if p1 - p0 < 0.5:
                continue
            start_pt = point_at_param(poly, p0); end_pt = point_at_param(poly, p1)
            i0, i1 = int(math.ceil(p0)), int(math.floor(p1))
            mid_pts = poly[i0:i1 + 1] if i0 <= i1 else []
            seg_pts = [start_pt] + mid_pts + [end_pt]
            cleaned = [seg_pts[0]]
            for pt in seg_pts[1:]:
                if dist(pt, cleaned[-1]) > 0.01:
                    cleaned.append(pt)
            if len(cleaned) < 2:
                continue
            subsegments.append({"road": n, "seg_idx": seg_idx, "pts": cleaned, "start_j": j0, "end_j": j1})
            seg_idx += 1

    # ---- 3. lane curves per sub-segment ----
    lane_curves = {}
    for s in subsegments:
        simplified = rdp(s["pts"], RDP_TOL)
        if len(simplified) < 4:
            simplified = pad_to_min_points(simplified, 4)
        # +LANE_OFFSET_M for laneB (not -) is not a typo: offset_points()'s
        # normal is the forward tangent rotated +90 degrees in (x,z), which
        # in this map's actual XZ orientation lands on the LEFT of the
        # direction of travel, not the right. +LANE_OFFSET_M is what puts
        # laneB on the right-hand side in-game -- confirmed empirically
        # in-game after the network read as mirrored (right-hand traffic on
        # the left) with the mathematically-"expected" sign.
        laneB = offset_points(simplified, +LANE_OFFSET_M)
        laneA = list(reversed(offset_points(simplified, -LANE_OFFSET_M)))
        lane_curves[(s["road"], s["seg_idx"], "laneB")] = laneB
        lane_curves[(s["road"], s["seg_idx"], "laneA")] = laneA

    junction_incoming = {j.id: [] for j in junctions}
    junction_outgoing = {j.id: [] for j in junctions}
    for s in subsegments:
        r, si = s["road"], s["seg_idx"]
        if s["start_j"] is not None:
            junction_outgoing[s["start_j"]].append((r, si, "laneB"))
            junction_incoming[s["start_j"]].append((r, si, "laneA"))
        if s["end_j"] is not None:
            junction_incoming[s["end_j"]].append((r, si, "laneB"))
            junction_outgoing[s["end_j"]].append((r, si, "laneA"))

    subseg_by_road = {}
    for s in subsegments:
        subseg_by_road.setdefault(s["road"], []).append(s)
    for r in subseg_by_road:
        subseg_by_road[r].sort(key=lambda s: s["seg_idx"])

    # ---- 4. connectors ----
    def arrival_tangent(pts):
        return norm((pts[-1][0] - pts[-2][0], pts[-1][1] - pts[-2][1]))
    def departure_tangent(pts):
        return norm((pts[1][0] - pts[0][0], pts[1][1] - pts[0][1]))

    def connector_pts(p0, tin, p2, tout):
        if dist(p0, p2) > BRIDGE_SPAN_M:
            # bridge deck: a straight line between banks, not a fillet curve
            # -- avoids a cosmetic wobble from fitting a Bezier handle across
            # a much longer-than-usual connector span. (Distance-based, not
            # junction-based: a junction like J4 can be a mix of normal short
            # fillets between roads that actually meet there, plus a manual
            # link's long bridge connector to a road that only reaches the
            # same spot via an unpainted bridge deck.)
            n = 5
            return [(p0[0] + (p2[0] - p0[0]) * i / (n - 1),
                     p0[1] + (p2[1] - p0[1]) * i / (n - 1)) for i in range(n)]
        p1 = line_intersect_point(p0, tin, p2, tout)
        handle_ok = p1 is not None and dist(p1, p0) <= MAX_HANDLE_DIST
        if not handle_ok:
            p1 = ((p0[0] + p2[0]) / 2, (p0[1] + p2[1]) / 2)
        return bezier_sample(p0, p1, p2, n=5)

    connectors = {}
    for jid in junction_incoming:
        for (ri, si, li) in junction_incoming[jid]:
            pts_in = lane_curves[(ri, si, li)]
            p0 = pts_in[-1]; tin = arrival_tangent(pts_in)
            for (ro, so, lo) in junction_outgoing[jid]:
                if (ri, si) == (ro, so):
                    continue
                pts_out = lane_curves[(ro, so, lo)]
                p2 = pts_out[0]; tout = departure_tangent(pts_out)
                connectors[(jid, (ri, si, li), (ro, so, lo))] = connector_pts(p0, tin, p2, tout)

    # ---- 4b. manual bridge links: exactly 2 direct connectors each, never
    # merged into an existing junction's turn combinatorics (see docstring).
    # If a traced bridge spline exists (bridge_traces, from bridge*_CSVdata.txt
    # -- the deck the user drew and hand-traced in GE) its real XZ path is used
    # for the interior shape instead of a straight line; the two endpoints are
    # still snapped exactly onto the adjoining lane curves so there's no gap.
    def lane_for_end(road, end):
        segs = subseg_by_road[road]
        seg = segs[0] if end == "start" else segs[-1]
        incoming_lane, outgoing_lane = ("laneA", "laneB") if end == "start" else ("laneB", "laneA")
        return seg, incoming_lane, outgoing_lane

    def road_end_point(seg, end):
        return seg["pts"][0] if end == "start" else seg["pts"][-1]

    def find_bridge_trace(posA, posB, tol=100.0):
        best_name, best_d = None, tol
        for name, pts in bridge_traces.items():
            d = min(dist(pts[0], posA) + dist(pts[-1], posB),
                    dist(pts[0], posB) + dist(pts[-1], posA))
            if d < best_d:
                best_name, best_d = name, d
        return best_name

    def traced_lane_curves(trace, posA, posB, snap_A_laneB, snap_B_laneB, snap_B_laneA, snap_A_laneA):
        # orient so the trace runs posA-side -> posB-side
        if dist(trace[-1], posA) < dist(trace[0], posA):
            trace = list(reversed(trace))
        center = [posA] + list(trace) + [posB]
        cleaned = [center[0]]
        for pt in center[1:]:
            if dist(pt, cleaned[-1]) > 0.5:
                cleaned.append(pt)
        simplified = rdp(cleaned, RDP_TOL)
        if len(simplified) < 4:
            simplified = pad_to_min_points(simplified, 4)
        laneB = offset_points(simplified, +LANE_OFFSET_M)
        laneA = list(reversed(offset_points(simplified, -LANE_OFFSET_M)))
        # snap the true endpoints onto the adjoining lane curves exactly, so
        # there's no visible/traffic-breaking gap at the junction
        laneB[0], laneB[-1] = snap_A_laneB, snap_B_laneB
        laneA[0], laneA[-1] = snap_B_laneA, snap_A_laneA
        return laneB, laneA

    bridge_connectors = {}
    for k, (roadA, endA, roadB, endB) in enumerate(MANUAL_BRIDGE_LINKS):
        segA, inA, outA = lane_for_end(roadA, endA)
        segB, inB, outB = lane_for_end(roadB, endB)
        pts_inA, pts_outA = lane_curves[(roadA, segA["seg_idx"], inA)], lane_curves[(roadA, segA["seg_idx"], outA)]
        pts_inB, pts_outB = lane_curves[(roadB, segB["seg_idx"], inB)], lane_curves[(roadB, segB["seg_idx"], outB)]

        p0, tin = pts_inA[-1], arrival_tangent(pts_inA)
        p2, tout = pts_outB[0], departure_tangent(pts_outB)
        p0b, tinb = pts_inB[-1], arrival_tangent(pts_inB)
        p2b, toutb = pts_outA[0], departure_tangent(pts_outA)

        posA, posB = road_end_point(segA, endA), road_end_point(segB, endB)
        trace_name = find_bridge_trace(posA, posB)
        if trace_name:
            print(f"manual bridge link {roadA}.{endA} <-> {roadB}.{endB}: using traced spline '{trace_name}'")
            pts1, connA_pts = traced_lane_curves(bridge_traces[trace_name], posA, posB, p0, p2, p0b, p2b)
        else:
            print(f"manual bridge link {roadA}.{endA} <-> {roadB}.{endB}: no traced spline found, using straight line")
            pts1 = connector_pts(p0, tin, p2, tout)
            connA_pts = connector_pts(p0b, tinb, p2b, toutb)

        name1 = f"br{k}_{roadA}{segA['seg_idx']}{inA}_to_{roadB}{segB['seg_idx']}{outB}"
        bridge_connectors[name1] = pts1
        name2 = f"br{k}_{roadB}{segB['seg_idx']}{inB}_to_{roadA}{segA['seg_idx']}{outA}"
        bridge_connectors[name2] = connA_pts

    print(f"\n{len(subsegments)} sub-segments, {len(lane_curves)} lane curves, "
          f"{len(connectors)} junction connector curves, {len(bridge_connectors)} manual bridge connector curves")

    # ---- 5. assemble i3d ----
    shapes_xml, scene_xml, attrs_xml = [], [], []
    shape_id, node_id = 1, 2

    def add_curve(name, pts, speed_limit, heights=None):
        nonlocal shape_id, node_id
        sid, nid = shape_id, node_id
        shape_id += 1; node_id += 1
        if heights is None:
            heights = [sample_height(x, z) for x, z in pts]
        cv_lines = "\n".join(
            f'                <cv c="{x:.3f} {h + SPLINE_CLEARANCE_M:.3f} {z:.3f}"/>'
            for (x, z), h in zip(pts, heights)
        )
        shapes_xml.append(f'        <NurbsCurve shapeId="{sid}" name="{name}" form="open">\n{cv_lines}\n        </NurbsCurve>')
        scene_xml.append(f'            <Shape name="{name}" shapeId="{sid}" nodeId="{nid}" visibility="true" castsShadows="false" receiveShadows="false"/>')
        attrs_xml.append(
            f'    <UserAttribute nodeId="{nid}">\n'
            f'        <Attribute name="maxSpeedScale" type="float" value="1"/>\n'
            f'        <Attribute name="speedLimit" type="float" value="{speed_limit}"/>\n'
            f'        <Attribute name="vehicleTypes" type="integer" value="1"/>\n'
            f'    </UserAttribute>'
        )

    for (road, seg, lane), pts in sorted(lane_curves.items()):
        add_curve(f"{road}_seg{seg}_{lane}", pts, 50 if road.startswith("primary") else 35)
    def bridge_heights_if_needed(pts):
        if dist(pts[0], pts[-1]) > BRIDGE_SPAN_M:
            # bridge deck: interpolate between the two bank heights, don't
            # sample the terrain underneath (it dips to the riverbed there)
            h0 = sample_height(*pts[0])
            h1 = sample_height(*pts[-1])
            n = len(pts)
            return [h0 + (h1 - h0) * (i / (n - 1)) for i in range(n)]
        return None

    for (jid, kin, kout), pts in sorted(connectors.items(), key=lambda kv: kv[0][0]):
        ri, si, li = kin; ro, so, lo = kout
        add_curve(f"j{jid}_{ri}{si}{li}_to_{ro}{so}{lo}", pts, 12, heights=bridge_heights_if_needed(pts))
    for name, pts in sorted(bridge_connectors.items()):
        add_curve(name, pts, 12, heights=bridge_heights_if_needed(pts))

    attrs_xml.insert(0,
        '    <UserAttribute nodeId="1">\n'
        '        <Attribute name="onCreate" type="scriptCallback" value="TrafficSystem.onCreate"/>\n'
        '        <Attribute name="xmlFile" type="string" value="map/config/trafficSystem.xml"/>\n'
        '    </UserAttribute>'
    )

    i3d = f'''<?xml version="1.0" encoding="iso-8859-1"?>
<i3D name="manvel_traffic_import" version="1.6" xsi:noNamespaceSchemaLocation="http://i3d.giants.ch/schema/i3d-1.6.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <Files/>
    <Materials/>
    <Shapes>
{chr(10).join(shapes_xml)}
    </Shapes>
    <Scene>
        <TransformGroup name="trafficSystem" nodeId="1">
{chr(10).join(scene_xml)}
        </TransformGroup>
    </Scene>
    <UserAttributes>
{chr(10).join(attrs_xml)}
    </UserAttributes>
</i3D>
'''
    with open(out_path, "w", encoding="iso-8859-1") as f:
        f.write(i3d)
    print(f"\nwrote {out_path}")


if __name__ == "__main__":
    main()

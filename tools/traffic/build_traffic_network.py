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
     paired lane, which would be a same-spot U-turn) with a cubic Bezier
     fillet whose control points are built directly from the arrival/
     departure tangent directions (p0 + tin*h, p2 - tout*h). This covers
     through movements and turns without needing to classify turn legality
     -- N legs -> N(N-1) movements.
  5. Assembles everything into one `trafficSystem` TransformGroup with a
     UserAttribute wiring it to map/config/trafficSystem.xml, plus per-curve
     speedLimit/maxSpeedScale/vehicleTypes UserAttributes -- see the SPEED_*
     constants for the values and the real-world reasoning behind them.

Curve fidelity: every point of each sub-segment's real centerline is kept,
point for point -- no simplification. Two earlier passes got this wrong in
different directions: the first used a coarse 2.0m RDP tolerance, flattening
long roads to 2-3 points and losing real curvature; the second tightened RDP
to 0.3m, which preserved the XZ shape but still measures only sideways
deviation from a straight line, blind to terrain height in between two kept
points -- on hilly ground a simplified straight segment could cut across a
hill/valley while its two endpoints still sampled correctly on the surface,
so the curve visibly dipped below ground between control points (same bug,
same fix, as snap_csvsplines_to_terrain.py). Keeping every point sidesteps
this entirely, at the cost of more control points (a few hundred per road
instead of a few dozen) -- GE handles that fine.

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
MAP_EDGE = 2040.0  # world coords beyond this are the playable-area boundary
# Speed limits in km/h, tuned for this map's setting: gravel section-line
# township roads on the one-mile grid northeast of Manvel, ND (Grand Forks
# County, Red River Valley). North Dakota's statutory limit is 55 mph on
# gravel/dirt roads and on unposted paved two-lane county/township roads, but
# 45/35 mph is what traffic actually moves at on loaded gravel -- and it plays
# better around farm equipment than a true 88 km/h would.
SPEED_PRIMARY = 72    # ~45 mph, the main gravel county roads
SPEED_SECONDARY = 56  # ~35 mph, the lighter secondary road
SPEED_BRIDGE = 72     # a bridge carries through traffic at road speed; these
                      # were previously stamped at the junction-turn speed,
                      # which had vehicles crawling across both river spans
SPEED_TURN = 25       # junction fillets -- slowing for a gravel corner
SPEED_UTURN = 15      # tight 180-degree map-edge turnarounds
VEHICLE_TYPES = 3  # bitmask of trafficSystem.xml typeFlag values a curve
                   # accepts: 1 = cars, 2 = large vehicles (trucks, buses).
                   # 3 = both. Every curve was previously stamped with 1, so
                   # the six typeFlag="2" vehicles in map/config/
                   # trafficSystem.xml (cementTruck, dumpTruck, both school
                   # buses, postalServiceTruck, tipperTruck) had nowhere to
                   # spawn and the log reported "No roads assigned for traffic
                   # vehicle ..." for each of them.
BRIDGE_SPAN_M = 25.0  # any connector longer than this is treated as a bridge
                       # deck: straight line + height interpolated between its
                       # two true endpoints, not sampled from the terrain
                       # underneath (real junction fillets are all <6m in this
                       # network, so this cleanly separates the two cases)
CONNECTOR_SAMPLES = 16  # points per junction-turn Bezier fillet.
HANDLE_FRACTION = 0.5  # cubic Bezier control-point handle length, as a
                       # fraction of the straight-line p0->p2 distance. See
                       # connector_pts() for why this replaced a line-
                       # intersection-based quadratic fillet.
LANE_SPACING_M = LANE_OFFSET_M * 2  # centre-to-centre distance between the
                       # two opposing lanes of a road. Derived, not a separate
                       # constant: both lanes are offset LANE_OFFSET_M from
                       # the same roadSystem centerline, on opposite sides.
                       # (6m road width -> 1.5m offset -> 3m lane spacing.)
TURN_SETBACK_M = LANE_OFFSET_M + LANE_SPACING_M  # = 4.5m. How far back up
                       # the incoming lane (and forward down the outgoing
                       # lane) a RIGHT-turn connector attaches, instead of at
                       # the lane curve's literal junction endpoint.
                       #
                       # Derived, not hand-picked. At a perpendicular
                       # junction a corner-cutting right turn of radius R is
                       # tangent to the incoming lane at LANE_OFFSET_M + R
                       # from the crossing point, so setback = offset + R.
                       # Setting R = LANE_SPACING_M (the turn is as wide as
                       # the road's two lanes are apart) gives the value
                       # above and makes the whole turn geometry scale with
                       # the road instead of being an unrelated constant.
                       # Setback = LANE_SPACING_M alone was tried and is too
                       # tight: it leaves R = 1.5m, a turn radius narrower
                       # than a single lane, which no vehicle can track.
                       # Left turns do NOT use this -- see the connector
                       # section for why.
TURN_SETBACK_MAX_FRAC = 0.4  # never eat more than this much of a short lane
THROUGH_DOT = 0.87     # cos(~30 deg): incoming/outgoing tangents at least
                       # this aligned count as a straight-through movement,
                       # which attaches endpoint-to-endpoint with no setback

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


def cubic_bezier_sample(p0, c1, c2, p2, n=5):
    out = []
    for i in range(n):
        t = i / (n - 1)
        mt = 1 - t
        x = mt ** 3 * p0[0] + 3 * mt ** 2 * t * c1[0] + 3 * mt * t ** 2 * c2[0] + t ** 3 * p2[0]
        z = mt ** 3 * p0[1] + 3 * mt ** 2 * t * c1[1] + 3 * mt * t ** 2 * c2[1] + t ** 3 * p2[1]
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
    free_terminals = []
    print("\nfree road endpoints (not auto-connected):")
    for n in names:
        poly = roads[n]
        for label, pt in (("start", poly[0]), ("end", poly[-1])):
            if (n, label) not in matched:
                edge = abs(pt[0]) > MAP_EDGE or abs(pt[1]) > MAP_EDGE
                tag = "map edge, closed with U-turn" if edge else "** NOT near map edge -- needs manual check **"
                print(f"  {n} {label} @ ({pt[0]:.1f},{pt[1]:.1f})  [{tag}]")
                if edge:
                    free_terminals.append((n, label))

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
    # NOTE: every point of each sub-segment's real centerline is kept here,
    # point for point -- no RDP simplification. RDP only measures how far a
    # point deviates sideways from a straight line; it has no idea about
    # terrain height in between two kept points, so on hilly ground a
    # simplified straight segment could cut across a hill/valley while its
    # two endpoints still sampled correctly on the surface -- the same bug
    # found and fixed in snap_csvsplines_to_terrain.py applies here too.
    lane_curves = {}
    for s in subsegments:
        simplified = s["pts"]
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

    def polyline_length(pts):
        return sum(dist(pts[i], pts[i + 1]) for i in range(len(pts) - 1))

    def setback_for(pts):
        return min(TURN_SETBACK_M, polyline_length(pts) * TURN_SETBACK_MAX_FRAC)

    def branch_from_end(pts, back):
        # walk backwards along the lane from its junction end; return the
        # point `back` metres up-road, the direction of travel there, and the
        # index of the first point PAST it (so the lane can be trimmed to
        # pts[:idx] + [p] if this branch is its only continuation)
        acc = 0.0
        for i in range(len(pts) - 1, 0, -1):
            seg = dist(pts[i], pts[i - 1])
            if seg <= 0:
                continue
            if acc + seg >= back:
                t = (back - acc) / seg
                p = (pts[i][0] + (pts[i - 1][0] - pts[i][0]) * t,
                     pts[i][1] + (pts[i - 1][1] - pts[i][1]) * t)
                return p, norm((pts[i][0] - pts[i - 1][0], pts[i][1] - pts[i - 1][1])), i
            acc += seg
        return pts[0], departure_tangent(pts), 1

    def merge_from_start(pts, fwd):
        # walk forwards along the lane from its junction end; return the point
        # `fwd` metres down-road, the direction of travel there, and the index
        # of the first point PAST it (so the lane can be trimmed to
        # [p] + pts[idx:] if this merge is its only origin)
        acc = 0.0
        for i in range(len(pts) - 1):
            seg = dist(pts[i], pts[i + 1])
            if seg <= 0:
                continue
            if acc + seg >= fwd:
                t = (fwd - acc) / seg
                p = (pts[i][0] + (pts[i + 1][0] - pts[i][0]) * t,
                     pts[i][1] + (pts[i + 1][1] - pts[i][1]) * t)
                return p, norm((pts[i + 1][0] - pts[i][0], pts[i + 1][1] - pts[i][1])), i + 1
            acc += seg
        return pts[-1], arrival_tangent(pts), len(pts) - 1

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
        # Cubic Bezier with tangent-scaled handles -- guarantees the curve
        # LEAVES p0 heading in the tin direction and ARRIVES at p2 heading in
        # the tout direction, for any relative angle between the two roads.
        #
        # The previous approach found the single quadratic-Bezier control
        # point as the intersection of the two full tangent LINES (not rays).
        # That's fine when the intersection happens to land in front of both
        # p0 and p2, but for plenty of real junction geometries here (e.g.
        # j8_secondaryRoad010laneA_to_primaryRoad022laneB, a ~90 degree turn
        # with a short lane-offset span) the lines only cross BEHIND p0
        # relative to tin -- confirmed numerically for that exact curve, the
        # control point sat back in the direction the vehicle had *come*
        # from, so the fillet's initial tangent pointed 180 degrees opposite
        # the arrival direction. The curve still math-out to a simple
        # (non-looping) parabola, but visually it left the junction backward
        # before turning, which read as a curve "rotated 180 degrees" /
        # rendered as a loop when overlaid with the junction's other, correct
        # connectors. Building the handles directly from tin/tout instead of
        # an unconstrained line intersection can't produce that reversal.
        handle_len = dist(p0, p2) * HANDLE_FRACTION
        c1 = (p0[0] + tin[0] * handle_len, p0[1] + tin[1] * handle_len)
        c2 = (p2[0] - tout[0] * handle_len, p2[1] - tout[1] * handle_len)
        return cubic_bezier_sample(p0, c1, c2, p2, n=CONNECTOR_SAMPLES)

    # Where a connector ATTACHES depends on which way the movement turns,
    # because right and left turns are geometrically different manoeuvres in
    # right-hand traffic:
    #
    #   RIGHT turns cut the near corner. They branch off the approach lane
    #   BEFORE the intersection and merge into the target lane AFTER it, so
    #   they attach TURN_SETBACK_M back up the incoming lane and the same
    #   distance forward down the outgoing lane, with tangents taken at those
    #   branch/merge points. This is also what fixes the dome/loop shapes:
    #   both lane endpoints sit within ~LANE_OFFSET_M of the centerline
    #   crossing, so at a 90-degree junction they're ~2m apart AND the
    #   outgoing lane's start lies *behind* the incoming lane's arrival
    #   direction (it's offset to the far side of the crossing). A curve
    #   forced to leave p0 along tin, travel 2m, and arrive at a p2 that's
    #   backwards of tin has to double back on itself -- no Bezier
    #   reformulation fixes that, because the endpoints themselves are wrong
    #   for the manoeuvre. Setting back gives the turn a real radius and puts
    #   p2 genuinely ahead of p0. The connector overlaps the through lane for
    #   that stretch, which is correct: the through movement and the right
    #   turn share the approach.
    #
    #   LEFT turns cross the intersection box instead. They run from the
    #   approach lane's stop line -- its literal junction endpoint -- through
    #   the middle of the junction to the target lane's literal start point.
    #   Setting these back is wrong: it pushes both ends out into the
    #   approach lanes and produces a much-too-wide arc that starts short of
    #   the line it should be leaving from (and lands short of the lane it
    #   should be joining). Their endpoints don't suffer the reversal problem
    #   above, because a left target sits ahead of the arrival direction, not
    #   behind it.
    #
    # Straight-through movements (tangents within ~30 degrees) also attach
    # endpoint-to-endpoint -- they have no radius to give, and setting them
    # back would just lay a redundant 12m spline on top of two lanes that
    # already meet.
    def turn_sign(tin, tout):
        # +x is east and +z is SOUTH here (map image row 0 is z=-2048), so
        # this (x,z) frame is screen-handed: a positive cross product is a
        # clockwise = RIGHT turn.
        return tin[0] * tout[1] - tin[1] * tout[0]

    connectors = {}
    skipped_zero_gap = 0
    right_count = left_count = through_count = 0
    # per-lane movement bookkeeping, used afterwards to decide whether a lane
    # should be TRIMMED back to its right turn's branch/merge point
    out_moves = {}  # incoming lane key -> [(is_right, branch_point, idx), ...]
    in_moves = {}   # outgoing lane key -> [(is_right, merge_point, idx), ...]
    for jid in junction_incoming:
        for (ri, si, li) in junction_incoming[jid]:
            pts_in = lane_curves[(ri, si, li)]
            tin_end = arrival_tangent(pts_in)
            for (ro, so, lo) in junction_outgoing[jid]:
                if (ri, si) == (ro, so):
                    continue
                pts_out = lane_curves[(ro, so, lo)]
                tout_start = departure_tangent(pts_out)
                is_through = (tin_end[0] * tout_start[0] + tin_end[1] * tout_start[1]) > THROUGH_DOT
                is_right = (not is_through) and turn_sign(tin_end, tout_start) > 0
                if is_right:
                    p0, tin, i_in = branch_from_end(pts_in, setback_for(pts_in))
                    p2, tout, i_out = merge_from_start(pts_out, setback_for(pts_out))
                    out_moves.setdefault((ri, si, li), []).append((True, p0, i_in))
                    in_moves.setdefault((ro, so, lo), []).append((True, p2, i_out))
                    right_count += 1
                else:
                    p0, tin = pts_in[-1], tin_end
                    p2, tout = pts_out[0], tout_start
                    if dist(p0, p2) < 0.05:
                        # the two lane curves already meet at (essentially)
                        # the exact same point. A "connector" here would be a
                        # zero-length curve with all control points identical,
                        # which GE renders as a degenerate loop, not a point.
                        skipped_zero_gap += 1
                        continue
                    out_moves.setdefault((ri, si, li), []).append((False, p0, None))
                    in_moves.setdefault((ro, so, lo), []).append((False, p2, None))
                    if is_through:
                        through_count += 1
                    else:
                        left_count += 1
                connectors[(jid, (ri, si, li), (ro, so, lo))] = connector_pts(p0, tin, p2, tout)
    if skipped_zero_gap:
        print(f"skipped {skipped_zero_gap} zero-gap connector(s) (lane curves already meet exactly)")
    print(f"{right_count} right turn(s) branched {TURN_SETBACK_M}m back from the junction, "
          f"{left_count} left turn(s) + {through_count} through movement(s) endpoint-to-endpoint")

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
        simplified = cleaned  # point for point -- no RDP simplification, see step 3's note
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

    # ---- 4b2. close map-edge terminals with U-turns ----
    # FS25's traffic AI requires every spline to form a closed loop. A lane
    # that simply stops -- which is what every road running off the edge of the
    # playable area did -- is reported as
    #   "Error: Traffic system road spline '<name>' dead-end found at <x> <z>"
    # and the spline is then silently ignored, so no vehicles ever spawn on it.
    # With 11 such terminals on this map, covering most of the main through
    # routes, that alone was enough to leave the whole network carless even
    # though it loaded without complaint otherwise.
    #
    # Each terminal has two lanes: one arriving there (its END) and one
    # departing from there (its START). Joining them with a tight 180-degree
    # bend turns the pair into a closed circuit -- traffic reaching the map
    # boundary turns around and comes back. The bend sits at/just past the
    # boundary, outside the playable area, so it isn't visible in normal play.
    uturn_connectors = {}
    for road, end in free_terminals:
        seg, lin, lout = lane_for_end(road, end)
        pts_in = lane_curves[(road, seg["seg_idx"], lin)]
        pts_out = lane_curves[(road, seg["seg_idx"], lout)]
        p0, tin = pts_in[-1], arrival_tangent(pts_in)
        p2, tout = pts_out[0], departure_tangent(pts_out)
        # handles along each lane's own direction of travel; a U-turn's two
        # tangents are near-opposite, so line-intersection handles are
        # degenerate here and the cubic form is required
        h = LANE_SPACING_M
        c1 = (p0[0] + tin[0] * h, p0[1] + tin[1] * h)
        c2 = (p2[0] - tout[0] * h, p2[1] - tout[1] * h)
        uturn_connectors[f"edge_{road}_{end}_uturn"] = cubic_bezier_sample(
            p0, c1, c2, p2, n=CONNECTOR_SAMPLES)
    if uturn_connectors:
        print(f"closed {len(uturn_connectors)} map-edge terminal(s) with U-turn connectors")

    # ---- 4c. trim lanes whose ONLY continuation is a right turn ----
    # A right turn's setback deliberately overlaps the approach lane, because
    # normally the through movement uses that same stretch -- the turn branches
    # off a lane that keeps going. But at a 2-leg corner join (e.g. J7, where
    # primaryRoad06 simply becomes primaryRoad07) there IS no through movement:
    # the turn is the lane's only continuation, so the lane has nothing to do
    # past the branch point and visibly overshoots the corner. Same on the far
    # side -- the outgoing lane starts before the connector reaches it. Where a
    # lane has exactly one movement and it's a setback right turn, trim it to
    # meet the connector exactly.
    #
    # Lane ends pinned by MANUAL_BRIDGE_LINKS are never trimmed: bridge
    # connectors are built from those exact points (above), so trimming one
    # would open a gap at the bridge. This is per-SIDE, not per-lane -- a lane
    # can be pinned by a bridge at one end and still be trimmable at the
    # other. primaryRoad06_seg0_laneB is exactly that case: the bridge from
    # primaryRoad05 pins its START, while the corner join at J7 trims its END.
    bridge_pinned_ends, bridge_pinned_starts = set(), set()
    for roadA, endA, roadB, endB in MANUAL_BRIDGE_LINKS:
        for road, end in ((roadA, endA), (roadB, endB)):
            seg, lin, lout = lane_for_end(road, end)
            bridge_pinned_ends.add((road, seg["seg_idx"], lin))     # pts_in[-1]
            bridge_pinned_starts.add((road, seg["seg_idx"], lout))  # pts_out[0]

    # FS25 joins traffic splines ONLY at their endpoints. A right turn's
    # setback attaches part-way along the approach lane, and the engine
    # reports that as
    #   "Error: Traffic system road spline '<name>' dead-end found at <x> <z>"
    # then drops the spline -- which is why the setback turns loaded fine in GE
    # but produced no traffic. So the lane has to be genuinely CUT at each
    # branch/merge point, not overlapped:
    #
    #   [ start .. merge ]  exit stub   - junction -> where right turns rejoin
    #   [ merge .. branch ]  main body  - the long run between junctions
    #   [ branch .. end   ]  approach   - where right turns leave -> junction
    #
    # Every connector then meets a real endpoint, and the pieces meet each
    # other at the cut points. The one exception is a lane whose ONLY
    # continuation is that right turn (a 2-leg corner join like J7): there's no
    # through movement to use the stub, so keeping it would just create a new
    # dead end. Those get trimmed instead, as before.
    def right_cut(moves):
        for is_right, p, idx in moves or []:
            if is_right:
                return p, idx
        return None, None

    lane_output = {}
    split_count = trimmed_count = 0
    for key, pts in lane_curves.items():
        road, seg_idx, lane = key
        base = f"{road}_seg{seg_idx}_{lane}"
        pm, im = right_cut(in_moves.get(key))
        pb, ib = right_cut(out_moves.get(key))
        # a cut only makes sense if it leaves a real body behind it
        if pm is not None and pb is not None and im >= ib:
            pm = pb = None
        # Cutting is always safe for a bridge-pinned lane -- the stub piece
        # keeps the lane's original endpoint as its own, so the bridge
        # connector still meets a real endpoint. What is NOT safe is DROPPING
        # that stub: at J3, primaryRoad09's end is both a junction leg and a
        # bridge endpoint, and dropping the stub there deleted the very point
        # the bridge attaches to. So a bridge-pinned end never counts as a
        # sole continuation, and its stub is always kept.
        sole_out = len(out_moves.get(key, [])) == 1 and key not in bridge_pinned_ends
        sole_in = len(in_moves.get(key, [])) == 1 and key not in bridge_pinned_starts

        # Build all three pieces from the ORIGINAL point array using the
        # original cut indices. An earlier version re-indexed the branch cut
        # against the already-shortened body (off = ib - im), which was off by
        # one and made the approach stub pick up points from BEFORE the branch
        # point -- so the stub ran backwards and the engine reported
        # "Warning: abrupt change of traffic spline direction" at a 180-degree
        # reversal. merge_from_start returns the index of the first point past
        # pm; branch_from_end returns the index of the first point past pb.
        head = pts[:im] + [pm] if pm is not None else pts[0:0]
        tail = [pb] + pts[ib:] if pb is not None else pts[0:0]
        lo = im if pm is not None else 0
        hi = ib if pb is not None else len(pts)
        body = ([pm] if pm is not None else []) + pts[lo:hi] + ([pb] if pb is not None else [])

        def emit(name, p):
            if len(p) < 2:
                return False
            lane_output[name] = pad_to_min_points(p, 4) if len(p) < 4 else p
            return True

        if pm is not None and not sole_in:
            if emit(f"{base}_exit", head):
                split_count += 1
        elif pm is not None:
            trimmed_count += 1
        if pb is not None and not sole_out:
            if emit(f"{base}_appr", tail):
                split_count += 1
        elif pb is not None:
            trimmed_count += 1
        emit(base, body)
    print(f"split {split_count} lane stub(s) off at right-turn branch/merge points, "
          f"dropped {trimmed_count} stub(s) with no through movement to serve")

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
            f'        <Attribute name="vehicleTypes" type="integer" value="{VEHICLE_TYPES}"/>\n'
            f'    </UserAttribute>'
        )

    for name, pts in sorted(lane_output.items()):
        add_curve(name, pts, SPEED_PRIMARY if name.startswith("primary") else SPEED_SECONDARY)
    for name, pts in sorted(uturn_connectors.items()):
        add_curve(name, pts, SPEED_UTURN)
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
        add_curve(f"j{jid}_{ri}{si}{li}_to_{ro}{so}{lo}", pts, SPEED_TURN, heights=bridge_heights_if_needed(pts))
    for name, pts in sorted(bridge_connectors.items()):
        add_curve(name, pts, SPEED_BRIDGE, heights=bridge_heights_if_needed(pts))

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

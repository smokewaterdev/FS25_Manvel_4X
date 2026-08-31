#!/usr/bin/env python3
"""
Generate a drop-in replacement for the `CSVSplines` group in map.i3d, with
every spline's control points snapped flush to the real terrain height.

The "Spline CSV Creator Panel OBJ_25" GE script (the same tool used to
export road centerlines for the traffic network / PDA map) leaves a
`<name>_CSV` reference spline behind in the scene as a byproduct of each
export, all grouped under a `CSVSplines` TransformGroup. Those splines'
control points don't reliably sit on the ground -- fixing that by hand means
editing every point of every spline in GE.

Instead: this reads the same map/CSVdata3/<name>_CSVdata.txt files the
exporter already produced (X/Z path data -- see build_ingame_roads.py's
docstring for the CSV format and why its height column isn't used), and
regenerates each spline with Y = real terrain height (from map/data/dem.png,
bilinear-sampled, same heightScale=255 convention as the traffic network)
plus a small clearance -- point for point, every original CSV sample kept,
no simplification. (An earlier version RDP-simplified these down to a
handful of control points, which is fine for a road's *shape* but wrong
for terrain-following: RDP only measures how far a point deviates
sideways from a straight line, it has no idea about ground height in
between two kept points, so on hilly terrain a simplified straight segment
could cut across a hill/valley while its two endpoints still sat correctly
on the surface -- the spline visibly dipped below ground between control
points. Sampling every point avoids that.) Output is a standalone
importable i3d: delete the existing `CSVSplines` group in GE and import
this file in its place -- shape/group names match exactly, so it's a clean
swap.

Usage:
  python3 snap_csvsplines_to_terrain.py [mod_root] [out_i3d]
"""
import sys, os, glob, math
from PIL import Image
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
HEIGHT_SCALE = 255.0
SPLINE_CLEARANCE_M = 0.1
RDP_TOL = 0.3

# The original CSVSplines group (like roadSystem) is NOT a zero-translation
# top-level group in map.i3d -- it carries this translation, and every
# child shape's geometry is stored LOCAL to it. The first generated version
# of this script wrote absolute-world CVs under a zero-translation group,
# which imported in the wrong place; the user confirmed re-adding this
# translation to the group (read directly off the original CSVSplines
# group's Translate X/Y/Z in GE) fixed it. Baked in here now so future runs
# don't need that manual step -- every CV below is written relative to this
# offset (world_pos - GROUP_TRANSLATION), with the offset itself set as the
# wrapping TransformGroup's own translation, so the absolute result is
# unchanged from what was already confirmed correct.
GROUP_TRANSLATION = (274.869, 1.06088, -177.953)


def dist(a, b):
    return math.hypot(a[0] - b[0], a[1] - b[1])


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


def load_dem_sampler(mod_root):
    dem_path = os.path.join(mod_root, "map", "data", "dem.png")
    dem = np.array(Image.open(dem_path)).astype(np.float64)
    h, w = dem.shape

    def sample(x, z):
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


def parse_csv(path):
    pts = []
    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            parts = line.split(",")
            if len(parts) != 3:
                continue
            z, x, _ht = (float(p) for p in parts)
            pts.append((round(x, 3), round(z, 3)))
    return pts


def main():
    mod_root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "..", "..")
    out_path = sys.argv[2] if len(sys.argv) > 2 else os.path.join(HERE, "csvsplines_terrain_snap.i3d")
    csv_dir = os.path.join(mod_root, "map", "CSVdata3")
    sample_height = load_dem_sampler(mod_root)

    files = sorted(glob.glob(os.path.join(csv_dir, "*_CSVdata.txt")))
    if not files:
        print(f"no CSV files found in {csv_dir}")
        sys.exit(1)

    shapes_xml, scene_xml = [], []
    shape_id, node_id = 1, 2

    def bridge_heights(points):
        # A bridge deck doesn't follow the ground underneath it -- sampling
        # the DEM at every point (like every other spline here) puts a
        # bridge spline down at riverbed/valley height, since that's what's
        # actually under it. Instead: sample the terrain only at the two
        # true endpoints (the banks) and interpolate linearly by
        # cumulative arc length across the points in between, matching how
        # build_traffic_network.py handles the same problem for the actual
        # bridge traffic connectors.
        h0 = sample_height(*points[0])
        h1 = sample_height(*points[-1])
        seg_lens = [dist(points[i], points[i + 1]) for i in range(len(points) - 1)]
        total = sum(seg_lens) or 1.0
        heights, acc = [h0], 0.0
        for L in seg_lens:
            acc += L
            heights.append(h0 + (h1 - h0) * (acc / total))
        return heights

    for path in files:
        name = os.path.basename(path).replace("_CSVdata.txt", "")
        pts = parse_csv(path)
        if len(pts) < 2:
            print(f"skipping {name}: only {len(pts)} point(s)")
            continue
        # NOTE: every original point is kept, point for point -- no RDP
        # simplification here. RDP only measures XZ deviation from a
        # straight line; it has no idea about terrain height in between two
        # kept points. On hilly ground that let a simplified straight
        # segment cut across a hill/valley while its two endpoints still
        # sampled correctly on the surface, so the curve visibly dipped
        # below (or floated above) ground between control points. Sampling
        # every point avoids that -- it's exactly as dense as the original
        # CSV export.
        points = pad_to_min_points(pts, 4) if len(pts) < 4 else pts

        is_bridge = name.startswith("bridge")
        heights = bridge_heights(points) if is_bridge else [sample_height(x, z) for x, z in points]

        sid, nid = shape_id, node_id
        shape_id += 1; node_id += 1
        gx, gy, gz = GROUP_TRANSLATION
        cv_lines = "\n".join(
            f'                <cv c="{x - gx:.3f} {h + SPLINE_CLEARANCE_M - gy:.3f} {z - gz:.3f}"/>'
            for (x, z), h in zip(points, heights)
        )
        shapes_xml.append(f'        <NurbsCurve shapeId="{sid}" name="{name}_CSV" form="open">\n{cv_lines}\n        </NurbsCurve>')
        scene_xml.append(f'            <Shape name="{name}_CSV" shapeId="{sid}" nodeId="{nid}" visibility="true" castsShadows="false" receiveShadows="false"/>')
        tag = "bridge deck, interpolated" if is_bridge else "terrain-snapped"
        print(f"{name:16s} {len(pts):5d} pts -> {len(points):4d} control points (point for point), {tag}")

    i3d = f'''<?xml version="1.0" encoding="iso-8859-1"?>
<i3D name="csvsplines_terrain_snap" version="1.6" xsi:noNamespaceSchemaLocation="http://i3d.giants.ch/schema/i3d-1.6.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <Files/>
    <Materials/>
    <Shapes>
{chr(10).join(shapes_xml)}
    </Shapes>
    <Scene>
        <TransformGroup name="CSVSplines" translation="{GROUP_TRANSLATION[0]} {GROUP_TRANSLATION[1]} {GROUP_TRANSLATION[2]}" nodeId="1">
{chr(10).join(scene_xml)}
        </TransformGroup>
    </Scene>
</i3D>
'''
    with open(out_path, "w", encoding="iso-8859-1") as f:
        f.write(i3d)
    print(f"\nwrote {out_path}  ({len(scene_xml)} splines)")


if __name__ == "__main__":
    main()

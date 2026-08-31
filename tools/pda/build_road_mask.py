#!/usr/bin/env python3
"""
Build the real road mask straight from the live map's own terrain texture
data, caching it as sources/road_mask.png (4096x4096, 8-bit: 255=road).

Same fix as build_forest_mask.py and build_water_mask.py: the previous
roads layer combined an OSM trace (for minor roads) with the real
primary/secondary splines exported from GE (see build_ingame_roads.py) --
but several OSM ways turned out to be the SAME physical road as a live
spline (OSM just tags rural roads unclassified/tertiary/residential rather
than primary/secondary), so both got drawn a few meters apart from the
OSM/live drift. That's the "drawn twice" look.

Checking the terrain's own ground-texture weight maps
(map/data/*_weight.png) found the real fix: this map paints every road
surface -- both the built primary/secondary roads AND the minor section-
line/farmyard-access roads -- with the gravel texture layers (gravel01/02,
gravelSmall01/02). Every asphalt/concrete layer in this map is essentially
unpainted (a handful of stray pixels, not real roads), so gravel is the
only road surface actually used here. Verified: 100% of the exported
primary/secondary spline points fall inside this mask, confirming it's the
same live geometry, not a second, independently-positioned road layer --
so this single mask can replace BOTH the OSM road trace and the separate
ingame-spline line-drawing, with no duplication and no drift, since it's
one live data source for the whole road network.

Usage:
  python3 build_road_mask.py [mod_root]
"""
import sys, os, json
import numpy as np
import cv2
from skimage.morphology import skeletonize
from skimage.measure import label
from PIL import Image, ImageDraw

HERE = os.path.dirname(os.path.abspath(__file__))

ROAD_LAYERS = ["gravel01", "gravel02", "gravelSmall01", "gravelSmall02"]
THRESHOLD = 10
# the painted gravel texture is only ~7px wide natively (a realistic road
# width at this map's 1px=1m scale) and its width isn't even consistent
# (wider at farmyard aprons/intersections, narrower on straightaways --
# padding it out with a plain dilate just inflates that unevenness into
# visible "bubbles"). Skeletonizing collapses it to a 1px centerline first,
# then a fixed-radius dilate off THAT gives a genuinely uniform road width
# everywhere, same as how a real road-line-width style works.
ROAD_WIDTH_RADIUS_PX = 8

# The primary/secondary roads have an even better source than this texture
# mask: the exact spline geometry exported from GE (sources/ingame_roads.json,
# drawn by draw_roads_ingame_overlay() in build_pda_v2.py). Layering a clean
# vector line on top of this raster mask left a faint second strip visible
# alongside it wherever the gravel paint's own centerline didn't land on
# exactly the same pixels as the spline -- a few px of drift is normal for
# hand-painted texture vs. exact vector data. Fix: cut a corridor out of the
# base mask along every spline BEFORE skeletonizing, sized a bit wider than
# the final road width, so the texture pipeline only ever has to reconstruct
# the minor roads/driveways that have no spline coverage at all. The overlay
# then draws the primary/secondary roads cleanly with nothing underneath.
SPLINE_CORRIDOR_RADIUS_PX = ROAD_WIDTH_RADIUS_PX + 4

# A handful of the gravel-texture blobs are just stray paint -- a fleck too
# small/isolated to be an actual road or driveway -- that close()+skeletonize
# still turns into a tiny standalone skeleton fragment, which the fixed-width
# dilate then blows up into a lone circular "nub" floating off the road with
# nothing connecting it to anything (that's the artifact the user flagged --
# a little dead-end dot hanging under the main road). Real road/driveway
# skeleton components in this map are all >=25px long; the noise specks are
# <=10px, so a threshold in that gap cleanly separates the two.
MIN_SKELETON_COMPONENT_PX = 15


def find_layer_file(data_dir, base):
    for suffix in ("_weight.png", ".png"):
        p = os.path.join(data_dir, base + suffix)
        if os.path.exists(p):
            return p
    return None


def to_px(pt):
    # same convention as build_pda_v2.py: pixel = world + 2048
    return (pt[0] + 2048.0, pt[1] + 2048.0)


def spline_corridor_mask(ingame_roads_path, size):
    with open(ingame_roads_path) as f:
        ingame_roads = json.load(f)
    W, H = size
    corridor = Image.new("L", (W, H), 0)
    d = ImageDraw.Draw(corridor)
    width = SPLINE_CORRIDOR_RADIUS_PX * 2 + 1
    for cls in ("primary", "secondary"):
        for seg in ingame_roads.get(cls, []):
            pts = [to_px(p) for p in seg["pts"]]
            if len(pts) >= 2:
                d.line(pts, fill=255, width=width, joint="curve")
    return np.array(corridor) > 0


def main():
    mod_root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "..", "..")
    data_dir = os.path.join(mod_root, "map", "data")

    combined = None
    used = []
    for base in ROAD_LAYERS:
        path = find_layer_file(data_dir, base)
        if path is None:
            print(f"  (missing: {base})")
            continue
        a = np.array(Image.open(path).convert("L"))
        combined = a if combined is None else np.maximum(combined, a)
        used.append(base)

    if combined is None:
        print("no road texture layers found")
        sys.exit(1)

    mask = (combined > THRESHOLD).astype(np.uint8) * 255
    print(f"used {len(used)} layers: {used}")
    print(f"road coverage (native paint width): {(mask > 0).mean() * 100:.2f}% of map")

    # cut out the primary/secondary spline corridor before doing anything
    # else, so this raster pipeline never reconstructs a road that the exact
    # vector overlay is about to draw on top of it anyway -- that's what was
    # causing the faint second strip alongside the main roads.
    ingame_roads_path = os.path.join(HERE, "sources", "ingame_roads.json")
    if os.path.exists(ingame_roads_path):
        corridor = spline_corridor_mask(ingame_roads_path, (mask.shape[1], mask.shape[0]))
        removed = ((mask > 0) & corridor).sum()
        mask[corridor] = 0
        print(f"removed {removed} px ({removed / mask.size * 100:.3f}% of map) inside spline corridor (radius={SPLINE_CORRIDOR_RADIUS_PX}px)")
    else:
        print("  (no ingame_roads.json -- skipping spline corridor exclusion)")

    # close small gaps in the paint first so the skeleton doesn't fracture
    # into disconnected segments at thin/sparsely-painted spots
    close_kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (7, 7))
    closed = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, close_kernel)

    skeleton = skeletonize(closed > 0)

    # drop tiny isolated skeleton fragments (stray texture paint, not real
    # roads) before they get dilated into floating nub artifacts
    lbl, n = label(skeleton, connectivity=2, return_num=True)
    sizes = np.bincount(lbl.ravel())
    dropped = 0
    for comp_id in range(1, n + 1):
        if sizes[comp_id] < MIN_SKELETON_COMPONENT_PX:
            skeleton[lbl == comp_id] = False
            dropped += 1
    print(f"dropped {dropped}/{n} skeleton components smaller than {MIN_SKELETON_COMPONENT_PX}px (noise)")

    skeleton_u8 = (skeleton.astype(np.uint8)) * 255
    print(f"skeleton coverage: {(skeleton_u8 > 0).mean() * 100:.3f}% of map")

    # uniform-width dilate off the centerline -- this is what actually
    # fixes the uneven "bubble" width, not just smooths edges
    width_kernel = cv2.getStructuringElement(
        cv2.MORPH_ELLIPSE, (ROAD_WIDTH_RADIUS_PX * 2 + 1,) * 2
    )
    mask = cv2.dilate(skeleton_u8, width_kernel)

    # one light blur+rethreshold pass to round off the residual per-pixel
    # jaggedness the skeleton's own staircase shape leaves in the dilate
    blurred = cv2.GaussianBlur(mask, (0, 0), sigmaX=2.5)
    mask = (blurred > 100).astype(np.uint8) * 255

    os.makedirs(os.path.join(HERE, "sources"), exist_ok=True)
    out_path = os.path.join(HERE, "sources", "road_mask.png")
    Image.fromarray(mask).save(out_path)
    print("saved", out_path, mask.shape)


if __name__ == "__main__":
    main()

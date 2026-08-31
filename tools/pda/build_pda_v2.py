#!/usr/bin/env python3
"""
Rebuild of the PDA sample renderer, done in reviewable stages instead of
compositing everything at once (which is how compose_pda.py made it hard to
tell which layer was actually wrong).

Usage:
  python3 build_pda_v2.py <mod_root> <stage> [out.png]

  stage: 1 = water only
         2 = water + forest
         3 = water + forest + fields
         4 = water + forest + fields + purchasable farmyards
         5 = water + forest + fields + farmyards + roads

Each stage is drawn on the same plain ground base so layers are easy to
compare side by side as they're added.
"""
import sys, os, json, math
import numpy as np
import cv2
from PIL import Image, ImageDraw

HERE = os.path.dirname(os.path.abspath(__file__))
CANVAS = 4096

# overview.dds does NOT represent just the 4096m playable square at 1:1 --
# decoding the game's original overview.dds and measuring the darker
# "playable area" tint in it shows that block sitting at pixel [1024,3072)
# on both axes, i.e. the CENTER HALF of the 4096x4096 texture. The full
# texture actually spans the 8192m MapToPlay DTM export box (see
# extract_osm_sources.py's comment on manvel.osm's <bounds>), with the
# playable 4096m square inset in the middle at 1 texture px = 2 world m --
# same uniform scale as the rest of the canvas, just a bigger area. Building
# the render at 1 px = 1 m across the whole canvas (the original assumption)
# made every real feature draw at exactly 2x the size the game expects,
# which is what showed up in-game as the field overlay reading "twice as
# big" as the background beneath it.
CONTEXT_HALF_EXTENT_M = 4096.0  # world meters spanned by half the canvas
INNER_SIZE = CANVAS // 2   # 2048px: the playable square, downscaled 2x
INNER_OFFSET = CANVAS // 4  # 1024px: where that square sits in the canvas

GROUND = (150, 158, 110)
WATER_COLOR = (95, 145, 160)
WATER_DITCH_COLOR = (140, 175, 180)
FOREST_COLOR = (35, 58, 30)
FIELD_BASE = (158, 120, 74)
FIELD_LINE = (120, 88, 50)
FARMYARD_COLOR = (176, 160, 132)

# a farmland parcel counts as a "purchasable farmyard" (not a crop farm) if
# less than this fraction of its pixels fall inside any field polygon
FARMYARD_FIELD_OVERLAP_MAX = 0.05


def to_px(pt):
    # world meters -> pixel (pixel = world + 2048), 1:1 at 4096 native res.
    # This is the INNER (playable-square) mapping only -- used while building
    # the precise 4096x4096 composite from live map data, which then gets
    # downscaled 2x and inset into the full context canvas (see main()).
    return (pt[0] + 2048.0, pt[1] + 2048.0)


# The OSM/lat-lon projection used for the outer context ring isn't quite
# grid-aligned with the live map's own coordinate frame -- roads that cross
# the playable-square boundary show a visible kink where the precise inner
# (live-data) geometry meets the OSM-derived outer geometry. Rotating the
# context points by a couple degrees before projecting them corrects this;
# positive = counter-clockwise as seen in the rendered top-down image.
# Tune by eye against a boundary crossing (e.g. the road exiting north out
# of the playable square) and re-render.
CONTEXT_ROTATION_DEG = 1.5


def _rotate_ccw(pt, deg):
    if deg == 0:
        return pt
    theta = math.radians(deg)
    c, s = math.cos(theta), math.sin(theta)
    x, z = pt
    # z increases downward on screen (see to_px/to_px_context, no sign flip),
    # so this is the mirror of the usual y-up CCW matrix -- verified against
    # a due-north test point rotating toward the west (11 o'clock) for +deg.
    return (x * c + z * s, -x * s + z * c)


def to_px_context(pt):
    # world meters -> pixel on the FULL 8192m-context canvas: 1 texture px =
    # 2 world m, canvas center = world origin. Used only for the outer
    # context background (OSM roads/forest/water beyond the playable square,
    # which has no live-map data of its own) -- see CONTEXT_HALF_EXTENT_M.
    x, z = _rotate_ccw(pt, CONTEXT_ROTATION_DEG)
    return ((x + CONTEXT_HALF_EXTENT_M) / 2.0, (z + CONTEXT_HALF_EXTENT_M) / 2.0)


def draw_water(draw, feats, include_ditches=False):
    # OSM-traced water (kept only for the include_ditches option below --
    # field drainage ditches have no live-map equivalent). The main river/
    # pond fill itself is drawn by draw_water_real() now; see that function
    # for why the OSM trace was replaced.
    if include_ditches:
        for wtr in feats.get("waterway", []):
            if wtr.get("sub") != "ditch":
                continue
            pts = [to_px(p) for p in wtr["pts"]]
            if len(pts) >= 2:
                draw.line(pts, fill=WATER_DITCH_COLOR, width=3, joint="curve")


def spline_corridor_mask(ingame_roads, size, radius):
    W, H = size
    corridor = Image.new("L", (W, H), 0)
    d = ImageDraw.Draw(corridor)
    width = radius * 2 + 1
    for cls in ("primary", "secondary"):
        for seg in ingame_roads.get(cls, []):
            pts = [to_px(p) for p in seg["pts"]]
            if len(pts) >= 2:
                d.line(pts, fill=255, width=width, joint="curve")
    return np.array(corridor) > 0


def draw_tributaries(im, draw, feats, ingame_roads=None, road_mask_path=None):
    # OSM-traced minor streams (waterway=stream/river not already covered by
    # the DEM-derived river/pond mask). Checked against dem.png directly:
    # this one isn't carved into the live terrain at all (values ~6600-7500,
    # same as ordinary farmland -- nowhere near the ~4400 water cutoff), so
    # unlike the main river this line is NOT validated against live terrain,
    # just the OSM trace as before. Flagged in the original version of this
    # comment as "kept because it reads well, flagged in case it ever looks
    # off" -- it did: near x=[1500,1800]/z=[-1800,-1300] this stream runs
    # right alongside a real road (both the primary spline AND a minor
    # gravel-texture driveway pass close by here) and the OSM/live drift
    # lands it a dozen-plus px from the road edge -- close enough to read as
    # a stray parallel line, not a ditch, but too far for a tight corridor
    # around just the spline centerline to catch. Fix: build the actual
    # combined road footprint (texture mask + spline overlay, exactly what
    # draw_roads_real/draw_roads_ingame_overlay put on screen) and dilate it
    # by a real buffer before cutting it out of the tributary mask, so any
    # OSM water line running close beside ANY drawn road -- not just
    # directly under one -- gets excluded, wherever that turns out to be.
    mask_im = Image.new("L", im.size, 0)
    mdraw = ImageDraw.Draw(mask_im)
    for wtr in feats.get("waterway", []):
        sub = wtr.get("sub")
        if sub not in ("river", "stream"):
            continue
        pts = [to_px(p) for p in wtr["pts"]]
        if len(pts) >= 2:
            width = 12 if sub == "river" else 7
            mdraw.line(pts, fill=255, width=width, joint="curve")

    mask = np.array(mask_im) > 0

    roads_present = (road_mask_path and os.path.exists(road_mask_path)) or ingame_roads is not None
    if roads_present:
        road_footprint = np.zeros((im.size[1], im.size[0]), dtype=bool)
        if road_mask_path and os.path.exists(road_mask_path):
            road_footprint |= np.array(Image.open(road_mask_path).convert("L")) > 0
        if ingame_roads is not None:
            road_footprint |= spline_corridor_mask(ingame_roads, im.size, ROAD_WIDTH_PX // 2)
        buffer_kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (41, 41))  # ~20px buffer
        road_buffer = cv2.dilate(road_footprint.astype(np.uint8), buffer_kernel) > 0
        mask &= ~road_buffer

    if not mask.any():
        return
    solid = Image.new("RGB", im.size, WATER_COLOR)
    im.paste(solid, (0, 0), Image.fromarray((mask.astype(np.uint8)) * 255))


def draw_water_real(im, water_mask_path):
    # Real water mask from the live map's own terrain heightmap (see
    # build_water_mask.py) -- guaranteed aligned with fields/forest since
    # all three come from the same live map. Replaces the OSM water trace,
    # which was measurably offset from the live map on tight meanders.
    mask = Image.open(water_mask_path).convert("L")
    solid = Image.new("RGB", im.size, WATER_COLOR)
    im.paste(solid, (0, 0), mask)


def draw_forest(draw, feats):
    for f in feats.get("forest", []):
        pts = [to_px(p) for p in f["pts"]]
        if len(pts) >= 3:
            draw.polygon(pts, fill=FOREST_COLOR)
    for tr in feats.get("tree_row", []):
        pts = [to_px(p) for p in tr["pts"]]
        if len(pts) >= 2:
            draw.line(pts, fill=FOREST_COLOR, width=10, joint="curve")


def draw_forest_real(im, forest_mask_path):
    # Real forest floor mask straight from the live map's terrain texture
    # data (see build_forest_mask.py) -- guaranteed aligned with fields
    # since both come from the same live map, unlike the OSM trace above.
    mask = Image.open(forest_mask_path).convert("L")
    solid = Image.new("RGB", im.size, FOREST_COLOR)
    im.paste(solid, (0, 0), mask)


def draw_fields(im, draw, fields):
    # Real per-field polygons from map.i3d (see build_fields.py), not the
    # farmland ownership raster -- shapes match what's actually tillable.
    H, W = im.size[1], im.size[0]
    yy, xx = np.mgrid[0:H, 0:W]
    hatch = (((xx + yy) // 5) % 3 == 0)
    hatch_img = Image.fromarray(
        np.where(hatch[..., None], FIELD_LINE, FIELD_BASE).astype("uint8")
    )
    mask = Image.new("L", (W, H), 0)
    mdraw = ImageDraw.Draw(mask)
    for field in fields:
        pts = [to_px(p) for p in field["pts"]]
        if len(pts) >= 3:
            mdraw.polygon(pts, fill=255)
    im.paste(hatch_img, (0, 0), mask)


def field_polygon_mask(fields, size):
    W, H = size
    mask_im = Image.new("L", (W, H), 0)
    d = ImageDraw.Draw(mask_im)
    for field in fields:
        pts = [to_px(p) for p in field["pts"]]
        if len(pts) >= 3:
            d.polygon(pts, fill=255)
    return np.array(mask_im) > 0


def draw_farmyards(im, draw, farmlands_png_path, fields):
    # Purchasable-but-not-tillable farmland parcels: the dealership,
    # cooperative/grain silo, farmers market, barge terminal, starting
    # farmyard, etc. Identified directly from the live farmland raster
    # (map/data/infoLayer_farmlands.png) rather than guessed at: any
    # farmland ID whose footprint barely overlaps any field polygon is,
    # by construction, a farmyard/commercial parcel rather than a crop
    # farm. This stays correct automatically as farmlands/fields change.
    farm = np.array(Image.open(farmlands_png_path))
    if farm.ndim == 3:
        farm = farm[..., 0]
    fmask = field_polygon_mask(fields, im.size)

    farmyard_mask = np.zeros(farm.shape, dtype=bool)
    for fid in np.unique(farm):
        if fid == 255:
            continue
        parcel = farm == fid
        total = parcel.sum()
        if total == 0:
            continue
        overlap = (parcel & fmask).sum() / total
        if overlap <= FARMYARD_FIELD_OVERLAP_MAX:
            farmyard_mask |= parcel

    if not farmyard_mask.any():
        return

    solid = Image.new("RGB", im.size, FARMYARD_COLOR)
    mask_img = Image.fromarray((farmyard_mask.astype(np.uint8)) * 255)
    im.paste(solid, (0, 0), mask_img)


ROAD_COLOR = (188, 183, 165)
ROAD_WIDTH_PX = 17  # match build_road_mask.py's ROAD_WIDTH_RADIUS_PX*2+1


def draw_roads_real(im, road_mask_path):
    # Real road mask from the live map's own terrain texture data (see
    # build_road_mask.py) -- covers the whole road network, including the
    # primary/secondary roads, at a uniform skeletonized width. Good enough
    # on its own for the minor roads/driveways that have no other source.
    mask = Image.open(road_mask_path).convert("L")
    solid = Image.new("RGB", im.size, ROAD_COLOR)
    im.paste(solid, (0, 0), mask)


def draw_roads_ingame_overlay(draw, ingame_roads):
    # But the primary/secondary roads DO have a better source: the exact
    # spline geometry exported from GE (build_ingame_roads.py) -- real
    # vector data, already perfectly smooth and uniform-width by
    # construction, no skeletonize/blur workaround needed. Drawn on top of
    # the texture-derived mask at the same width/color so it blends in
    # while replacing the texture-derived version specifically where a
    # spline exists (i.e. exactly the roads that don't need the raster
    # pipeline's help). Safe to layer over the mask rather than subtract
    # from it first: same road, same color, same width, so no doubling --
    # unlike the old OSM trace, this can't be positionally offset from the
    # texture mask since both come from the same live map.
    for cls in ("primary", "secondary"):
        for seg in ingame_roads.get(cls, []):
            pts = [to_px(p) for p in seg["pts"]]
            if len(pts) < 2:
                continue
            draw.line(pts, fill=ROAD_COLOR, width=ROAD_WIDTH_PX, joint="curve")


# highway tag -> (context line width px, draw order doesn't matter, single pass)
CONTEXT_ROAD_WIDTH = {
    "primary": 8, "secondary": 7, "tertiary": 6,
    "unclassified": 5, "residential": 5, "service": 4, "track": 3,
}
CONTEXT_ROAD_COLOR = (185, 180, 163)  # close to ROAD_COLOR, kept distinct in case it needs separate tuning
CONTEXT_FOREST_COLOR = (45, 65, 38)  # slightly lighter than the precise FOREST_COLOR -- reads as "coarser/farther" detail


def draw_context_background(feats):
    # The outer ring beyond the playable square (see CONTEXT_HALF_EXTENT_M)
    # has no live map data at all -- nothing was ever exported for terrain
    # outside the map's own bounds -- so this is OSM-traced only, same as
    # the early (pre-fix) versions of the inner layers were. That's fine
    # here: it's just background context the player can see beyond the farm,
    # not something gameplay depends on being pixel-accurate.
    im = Image.new("RGB", (CANVAS, CANVAS), GROUND)
    draw = ImageDraw.Draw(im)

    for f in feats.get("forest", []):
        pts = [to_px_context(p) for p in f["pts"]]
        if len(pts) >= 3:
            draw.polygon(pts, fill=CONTEXT_FOREST_COLOR)
    for tr in feats.get("tree_row", []):
        pts = [to_px_context(p) for p in tr["pts"]]
        if len(pts) >= 2:
            draw.line(pts, fill=CONTEXT_FOREST_COLOR, width=5, joint="curve")

    for w in feats.get("water", []):
        pts = [to_px_context(p) for p in w["pts"]]
        if len(pts) >= 3:
            draw.polygon(pts, fill=WATER_COLOR)
    for wtr in feats.get("waterway", []):
        sub = wtr.get("sub")
        if sub not in ("river", "stream"):
            continue
        pts = [to_px_context(p) for p in wtr["pts"]]
        if len(pts) >= 2:
            width = 6 if sub == "river" else 4
            draw.line(pts, fill=WATER_COLOR, width=width, joint="curve")

    for r in feats.get("road", []):
        pts = [to_px_context(p) for p in r["pts"]]
        if len(pts) >= 2:
            width = CONTEXT_ROAD_WIDTH.get(r.get("sub"), 3)
            draw.line(pts, fill=CONTEXT_ROAD_COLOR, width=width, joint="curve")

    return im


def build_inner(mod_root, stage, feats, ingame_roads):
    # The precise, live-map-derived playable-square composite -- everything
    # main() used to build directly at full canvas size before the context
    # fix. Still 4096x4096 at this point; main() downscales it 2x and insets
    # it into the context canvas afterwards.
    im = Image.new("RGB", (CANVAS, CANVAS), GROUND)
    draw = ImageDraw.Draw(im)

    # Draw order: fields sit on the base ground, farmyards go on top of
    # fields (they're a distinct land type), then water and forest go on
    # top of both so the river/tree cover correctly interrupt tilled land
    # and farmyards rather than either painting over them.
    fields = None
    if stage >= 3:
        fields_path = os.path.join(HERE, "sources", "field_polygons.json")
        with open(fields_path) as f:
            fields = json.load(f)
        draw_fields(im, draw, fields)
        draw = ImageDraw.Draw(im)  # re-bind after paste()
    if stage >= 4:
        farmlands_png_path = os.path.join(mod_root, "map", "data", "infoLayer_farmlands.png")
        draw_farmyards(im, draw, farmlands_png_path, fields)
        draw = ImageDraw.Draw(im)  # re-bind after paste()
    if stage >= 1:
        water_mask_path = os.path.join(HERE, "sources", "water_mask.png")
        if os.path.exists(water_mask_path):
            draw_water_real(im, water_mask_path)
            draw = ImageDraw.Draw(im)  # re-bind after paste()
        else:
            draw_water(draw, feats)  # fallback: OSM trace (not aligned to live fields)
        road_mask_path = os.path.join(HERE, "sources", "road_mask.png")
        draw_tributaries(im, draw, feats, ingame_roads, road_mask_path)
        draw = ImageDraw.Draw(im)  # re-bind after paste()
    if stage >= 2:
        forest_mask_path = os.path.join(HERE, "sources", "forest_mask.png")
        if os.path.exists(forest_mask_path):
            draw_forest_real(im, forest_mask_path)
            draw = ImageDraw.Draw(im)  # re-bind after paste()
        else:
            draw_forest(draw, feats)  # fallback: OSM trace (not aligned to live fields)
    if stage >= 5:
        road_mask_path = os.path.join(HERE, "sources", "road_mask.png")
        if os.path.exists(road_mask_path):
            draw_roads_real(im, road_mask_path)
            draw = ImageDraw.Draw(im)  # re-bind after paste()
        else:
            print("no road_mask.png -- run build_road_mask.py first")
        if ingame_roads is not None:
            draw_roads_ingame_overlay(draw, ingame_roads)

    return im


def main():
    mod_root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "..", "..")
    stage = int(sys.argv[2]) if len(sys.argv) > 2 else 1
    out_path = sys.argv[3] if len(sys.argv) > 3 else os.path.join(HERE, f"pda_stage{stage}.png")

    with open(os.path.join(HERE, "sources", "osm_features.json")) as f:
        feats = json.load(f)

    ingame_roads = None
    ingame_roads_path = os.path.join(HERE, "sources", "ingame_roads.json")
    if os.path.exists(ingame_roads_path):
        with open(ingame_roads_path) as f:
            ingame_roads = json.load(f)

    canvas = draw_context_background(feats)

    inner = build_inner(mod_root, stage, feats, ingame_roads)
    inner_small = inner.resize((INNER_SIZE, INNER_SIZE), Image.BOX)  # exact 2x box-average, no moire
    canvas.paste(inner_small, (INNER_OFFSET, INNER_OFFSET))

    canvas.save(out_path)
    print("saved", out_path, canvas.size)


if __name__ == "__main__":
    main()

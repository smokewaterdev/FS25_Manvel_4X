#!/usr/bin/env python3
"""
Regenerate the Manvel 4X sample PDA image from cached sources.

Sources (in ./sources/):
  - osm_features.json  : real-world roads/forest/water traced from manvel.osm,
                          pre-projected into map-local meters. Static; does not
                          need to be regenerated unless manvel.osm changes.
                          Covers motorway/tertiary/unclassified/residential/
                          service/track -- OSM has no primary/secondary-tagged
                          roads in this area.
  - ingame_roads.json  : the REAL built primary/secondary road splines from
                          map.i3d's roadSystem group, exported from GE via the
                          "Spline CSV Creator Panel OBJ_25" script and parsed
                          by build_ingame_roads.py. Regenerate that if the
                          roadSystem splines change.
  - calibration.json   : records exactly how the OSM projection was derived
                          and validated, for reference/reproducibility.

Live input (re-read every run, since it changes as you edit the map):
  - map/data/infoLayer_farmlands.png : current farmland footprints.

Usage:
  python3 compose_pda.py /path/to/FS25_Manvel_4X [output.png]
"""
import sys, os, json
import numpy as np
from PIL import Image, ImageDraw
import cv2

HERE = os.path.dirname(os.path.abspath(__file__))

def main():
    mod_root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "..")
    out_path = sys.argv[2] if len(sys.argv) > 2 else os.path.join(HERE, "pda_output.png")

    farm_path = os.path.join(mod_root, "map", "data", "infoLayer_farmlands.png")
    farm = np.array(Image.open(farm_path))
    H, W = farm.shape

    with open(os.path.join(HERE, "sources", "osm_features.json")) as f:
        feats = json.load(f)

    ingame_roads_path = os.path.join(HERE, "sources", "ingame_roads.json")
    ingame_roads = {"primary": [], "secondary": []}
    if os.path.exists(ingame_roads_path):
        with open(ingame_roads_path) as f:
            ingame_roads = json.load(f)

    def to_px(pt):
        # world meters -> pixel (pixel = world + 2048), no scaling needed at 4096 native res
        return (pt[0] + 2048.0, pt[1] + 2048.0)

    # ---- base ground ----
    GROUND = np.array([150, 158, 110], dtype=np.uint8)
    canvas = np.tile(GROUND, (H, W, 1)).astype(np.uint8)

    # ---- fields: tan hatch, clipped to current farmland footprint ----
    FIELD_BASE = np.array([158, 120, 74], dtype=np.uint8)
    FIELD_LINE = np.array([120, 88, 50], dtype=np.uint8)
    yy, xx = np.mgrid[0:H, 0:W]
    hatch = (((xx + yy) // 5) % 3 == 0)
    field_tex = np.where(hatch[..., None], FIELD_LINE, FIELD_BASE).astype(np.uint8)
    field_mask = farm != 255
    canvas[field_mask] = field_tex[field_mask]

    im = Image.fromarray(canvas)
    draw = ImageDraw.Draw(im)

    # ---- roads: real OSM geometry, width by class ----
    ROAD_COLOR = (168, 164, 150)
    ROAD_WIDTH = {
        "motorway": 12, "trunk": 12, "primary": 11,
        "secondary": 10, "tertiary": 9, "unclassified": 7,
        "residential": 7, "track": 4, "service": 4,
    }
    for road in feats.get("road", []):
        pts = [to_px(p) for p in road["pts"]]
        if len(pts) < 2:
            continue
        w = ROAD_WIDTH.get(road.get("sub"), 5)
        draw.line(pts, fill=ROAD_COLOR, width=w, joint="curve")

    # ---- roads: real in-game primary/secondary splines (roadSystem group) ----
    # Drawn on top of the OSM layer since these are the actual built roads,
    # not traced approximations. OSM has nothing tagged primary/secondary
    # here, so this doesn't replace OSM data -- it adds the layer OSM lacked.
    INGAME_ROAD_WIDTH = {"primary": 11, "secondary": 10}
    for cls in ("primary", "secondary"):
        for seg in ingame_roads.get(cls, []):
            pts = [to_px(p) for p in seg["pts"]]
            if len(pts) < 2:
                continue
            draw.line(pts, fill=ROAD_COLOR, width=INGAME_ROAD_WIDTH[cls], joint="curve")

    # ---- forest: real OSM polygons ----
    FOREST_COLOR = (58, 92, 46)
    for f in feats.get("forest", []):
        pts = [to_px(p) for p in f["pts"]]
        if len(pts) >= 3:
            draw.polygon(pts, fill=FOREST_COLOR)
    for tr in feats.get("tree_row", []):
        pts = [to_px(p) for p in tr["pts"]]
        if len(pts) >= 2:
            draw.line(pts, fill=FOREST_COLOR, width=10, joint="curve")

    # ---- water: real OSM polygons + waterway lines ----
    WATER_COLOR = (109, 156, 158)
    for wtr in feats.get("waterway", []):
        pts = [to_px(p) for p in wtr["pts"]]
        if len(pts) >= 2:
            width = 14 if wtr.get("sub") == "river" else (8 if wtr.get("sub") == "stream" else 5)
            draw.line(pts, fill=WATER_COLOR, width=width, joint="curve")
    for wp in feats.get("water", []):
        pts = [to_px(p) for p in wp["pts"]]
        if len(pts) >= 3:
            draw.polygon(pts, fill=WATER_COLOR)

    im.save(out_path)
    print("saved", out_path, im.size)

if __name__ == "__main__":
    main()

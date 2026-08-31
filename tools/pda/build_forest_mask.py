#!/usr/bin/env python3
"""
Build the real forest mask straight from the live map's own terrain texture
data, caching it as sources/forest_mask.png (4096x4096, 8-bit: 255=forest).

Why this exists: the previous forest layer came from manvel.osm (a static,
externally-sourced real-world trace), while fields come from map/map.i3d
(the actual live map). Those are two different, independently-calibrated
datasets, so they drift apart whenever the map's fields get hand-edited --
which is exactly what the user flagged ("fields and forests do not match
up"). This script instead reads the terrain's own forest-floor ground
texture weight maps (map/data/*_weight.png for the forest ground layers:
forestGrass, forestLeaves, forestNeedels, forestRockRoots, rockForest,
rockyForestGround, pebblesForestGround) -- wherever any of these textures
is painted is, by construction, the same forest the game itself renders,
so it lines up with fields/roads by definition since it's the same map.

Usage:
  python3 build_forest_mask.py [mod_root]
"""
import sys, os
import numpy as np
from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))

# Terrain ground-texture layers that represent forest floor. Some maps use
# the "_weight.png" suffix, a couple (forestRockRoots) don't -- try both.
FOREST_LAYERS = [
    "forestGrass01", "forestGrass02",
    "forestLeaves01", "forestLeaves02",
    "forestNeedels01", "forestNeedels02",
    "forestRockRoots01", "forestRockRoots02",
    "rockForest01", "rockForest02",
    "rockyForestGround01", "rockyForestGround02",
    "pebblesForestGround01", "pebblesForestGround02",
]
THRESHOLD = 10  # weight value (0-255) above which a pixel counts as "forest"


def find_layer_file(data_dir, base):
    for suffix in ("_weight.png", ".png"):
        p = os.path.join(data_dir, base + suffix)
        if os.path.exists(p):
            return p
    return None


def main():
    mod_root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "..", "..")
    data_dir = os.path.join(mod_root, "map", "data")

    combined = None
    used = []
    for base in FOREST_LAYERS:
        path = find_layer_file(data_dir, base)
        if path is None:
            print(f"  (missing: {base})")
            continue
        a = np.array(Image.open(path).convert("L"))
        combined = a if combined is None else np.maximum(combined, a)
        used.append(base)

    if combined is None:
        print("no forest texture layers found")
        sys.exit(1)

    mask = (combined > THRESHOLD).astype(np.uint8) * 255
    print(f"used {len(used)} layers: {used}")
    print(f"forest coverage: {(mask > 0).mean() * 100:.2f}% of map")

    os.makedirs(os.path.join(HERE, "sources"), exist_ok=True)
    out_path = os.path.join(HERE, "sources", "forest_mask.png")
    Image.fromarray(mask).save(out_path)
    print("saved", out_path, mask.shape)


if __name__ == "__main__":
    main()

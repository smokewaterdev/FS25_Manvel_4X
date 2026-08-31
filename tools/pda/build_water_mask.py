#!/usr/bin/env python3
"""
Build the real water mask straight from the live map's own terrain heightmap
(map/data/dem.png), caching it as sources/water_mask.png (4096x4096, 8-bit:
255=water).

Why this exists: the water layer previously came from manvel.osm (a static,
externally-sourced real-world trace, same issue as the old forest layer --
see build_forest_mask.py). It looked close at a glance but was measurably
offset from the live map on tight meanders, which is exactly what you'd
expect from an independently-calibrated external dataset drifting away from
a hand-edited live map. This script instead reads the terrain's own carved
riverbed: dem.png is the 16-bit terrain heightmap, and the river channel is
a genuine, sharply-cut low point in it -- thresholding below a cutoff picks
out exactly the carved channel, guaranteed aligned with fields/forest since
it's the same live terrain data.

How the threshold was picked: coverage vs. dem value has a sharp cliff
around 4000-4200 (0.003% -> 1.3%) -- that's the riverbank edge. 4400 was
then chosen by eye against the real forest mask (the river should run
centered in the forest corridor, similar apparent width) -- see
PDA_MAP_NOTES.md / pda/README.md for the validation crop. Re-tune WATER_DEM_THRESHOLD
and re-run if the terrain heightmap changes enough to shift this.

Usage:
  python3 build_water_mask.py [mod_root]
"""
import sys, os
import numpy as np
from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
WATER_DEM_THRESHOLD = 4400


def main():
    mod_root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "..", "..")
    dem_path = os.path.join(mod_root, "map", "data", "dem.png")

    dem = np.array(Image.open(dem_path))
    # dem.png is 4097x4097 (one extra row/col vs. the 4096 canvas -- typical
    # heightmap fencepost); crop to match everything else.
    dem = dem[:4096, :4096]

    mask = (dem <= WATER_DEM_THRESHOLD).astype(np.uint8) * 255
    print(f"water coverage: {(mask > 0).mean() * 100:.2f}% of map (threshold={WATER_DEM_THRESHOLD})")

    os.makedirs(os.path.join(HERE, "sources"), exist_ok=True)
    out_path = os.path.join(HERE, "sources", "water_mask.png")
    Image.fromarray(mask).save(out_path)
    print("saved", out_path, mask.shape)


if __name__ == "__main__":
    main()

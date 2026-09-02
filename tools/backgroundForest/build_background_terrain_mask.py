#!/usr/bin/env python3
"""
Generate assets/background_terrain/background_terrain_mask.png -- the blend
mask for background_terrain.i3d's backgroundTerrainShader material.

Why this exists: background_terrain.i3d used to be a single flat satellite
photo (background_terrain.dds) with no texture blending, so the map edge
read as an obvious photo cutoff past map_bounds. The material now uses the
vanilla backgroundTerrainShader (see assets/background_terrain/background_terrain.i3d
for the Material block), which blends up to 3 tiled textures over that base
photo using an RGB mask, sampled on the same UV0 channel as the base photo.

This mask encodes:
  R = grass blend weight: full strength (opaque) for the first PLATEAU
      meters past the +-2048 playable boundary, then tapering linearly to 0
      by FADE meters out -- softens the hard edge without touching the mesh
      itself. First pass (400m linear fade, no plateau) looked like only a
      "thin transparent strip" in-game per 2026-08-31 GE screenshots: a
      fade starting at full strength right at the boundary spends most of
      its range at low, hard-to-see opacity against a busy satellite photo,
      so only the innermost sliver reads as visibly green. The plateau
      fixes that by holding full opacity for a real, visible distance
      before the taper starts.
  G = forest-floor blend weight, wherever a real OSM forest polygon
      (tools/pda/sources/osm_features.json) actually is, dilated slightly
      to comfortably cover tree canopies/trunks -- keeps the new background
      trees (see build_background_forest_fill.py) from sitting on bare
      satellite-photo farmland.
  B = unused (0 everywhere); the shader's projDiffuse3 channel falls back
      to its own default texture and simply never gets blended in.

Load-bearing assumption, unverified as of 2026-08-31: background_terrain.dds
is 8192x8192px and is assumed to be a simple 1:1 world-aligned drape over
world X,Z in [-4096, 4096] (matching the known 8192m maps4fs DTM export
box), i.e. this mask needs to be pixel-for-pixel aligned to that same
projection to line up with the mesh's actual UV0. If the first in-game look
shows the blend offset/mirrored/rotated relative to the real map edge, that
assumption is what to revisit (try flipping the Z axis, or swapping row
order) rather than anything else in this script.

Usage:
  python3 build_background_terrain_mask.py [mod_root] [--res 2048] [--plateau 150] [--fade 600]
"""
import argparse
import json
import os
import subprocess

import numpy as np
from PIL import Image, ImageDraw
from scipy.ndimage import maximum_filter

HERE = os.path.dirname(os.path.abspath(__file__))
EXTENT = 8192.0  # world meters covered by background_terrain.dds, and this mask
HALF = EXTENT / 2.0
PLAYABLE_HALF = 2048.0
MIP_LEVELS = 12  # 2048 -> 1


def convert_to_dds(src_png, out_dds):
    """Pack the mask into a DXT1 (BC1) DDS with a baked mip chain, matching
    background_terrain.dds (its sibling in the same material).

    Must be block-compressed, not raw. GIANTS' "Texture ... raw format."
    performance warning fires on *uncompressed* textures specifically, so an
    uncompressed DDS does not silence it -- it just trades a 23KB PNG for a
    16.8MB raw texture and keeps the warning. DXT1 at 2048 with a full mip
    chain is ~2.8MB and the warning goes away.

    DXT1 (RGB, no alpha) is the right variant here: the mask uses R and G as
    the two projected-grass blend weights and leaves B unused. Block artifacts
    on a smooth fade are acceptable and are what the engine expects for a mask;
    they are not the photo-realistic case that needs careful UV handling (see
    CLAUDE.md on background_terrain mesh decimation).
    """
    subprocess.run(
        [
            "convert", src_png,
            "-define", "dds:compression=dxt1",
            "-define", "dds:mipmaps=" + str(MIP_LEVELS),
            out_dds,
        ],
        check=True,
    )


def world_to_px(x, z, res):
    px = (x + HALF) / EXTENT * res
    py = (z + HALF) / EXTENT * res
    return px, py


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("mod_root", nargs="?", default=os.path.join(HERE, "..", ".."))
    ap.add_argument("--res", type=int, default=2048, help="mask resolution in pixels (square)")
    ap.add_argument("--plateau", type=float, default=150.0, help="distance beyond the playable edge held at full grass opacity, in meters")
    ap.add_argument("--fade", type=float, default=600.0, help="total distance beyond the playable edge where grass reaches 0 (must be > --plateau), in meters")
    ap.add_argument("--dilate", type=float, default=12.0, help="forest-floor dilation radius, in meters")
    args = ap.parse_args()

    res = args.res
    osm_path = os.path.join(args.mod_root, "tools", "pda", "sources", "osm_features.json")
    out_path = os.path.join(args.mod_root, "assets", "background_terrain", "background_terrain_mask.png")

    xs = np.linspace(-HALF, HALF, res, endpoint=False) + (EXTENT / res) / 2
    zs = np.linspace(-HALF, HALF, res, endpoint=False) + (EXTENT / res) / 2
    gx, gz = np.meshgrid(xs, zs)
    inside_box = (np.abs(gx) <= PLAYABLE_HALF) & (np.abs(gz) <= PLAYABLE_HALF)

    dist_outside = np.maximum(np.maximum(np.abs(gx) - PLAYABLE_HALF, np.abs(gz) - PLAYABLE_HALF), 0)
    taper_span = max(args.fade - args.plateau, 1.0)
    grass = np.clip(1.0 - (dist_outside - args.plateau) / taper_span, 0, 1)
    grass[inside_box] = 0.0

    forest = json.load(open(osm_path))["forest"]
    forest_img = Image.new("L", (res, res), 0)
    draw = ImageDraw.Draw(forest_img)
    for f in forest:
        poly_px = [world_to_px(x, z, res) for x, z in f["pts"]]
        draw.polygon(poly_px, fill=255)
    forest_arr = np.array(forest_img).astype(np.float32) / 255.0
    px_per_m = res / EXTENT
    dilate_px = max(1, int(round(args.dilate * px_per_m)))
    forest_arr = maximum_filter(forest_arr, size=dilate_px * 2 + 1)
    forest_arr[inside_box] = 0.0

    mask_rgb = np.zeros((res, res, 3), dtype=np.uint8)
    mask_rgb[..., 0] = (grass * 255).astype(np.uint8)
    mask_rgb[..., 1] = (forest_arr * 255).astype(np.uint8)

    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    Image.fromarray(mask_rgb, mode="RGB").save(out_path)
    print(f"saved {out_path} ({res}x{res})")
    print(f"grass coverage: {(grass>0).mean()*100:.2f}%  forest coverage: {(forest_arr>0).mean()*100:.2f}%")

    dds_path = os.path.splitext(out_path)[0] + ".dds"
    convert_to_dds(out_path, dds_path)
    print(f"saved {dds_path} ({MIP_LEVELS} mips) -- this is the file background_terrain.i3d actually references")


if __name__ == "__main__":
    main()

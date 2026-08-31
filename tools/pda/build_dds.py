#!/usr/bin/env python3
"""
Package pda_output.png into map/overview.dds (and its overview-satellite.dds
companion), matching the game's own DDS format exactly: DXT1-compressed,
4096x4096, 13 mip levels.

This closes the one gap left in the PDA pipeline (see README.md's "DDS
packaging" section) -- everything up to pda_output.png was already a saved,
rerunnable script; this was the one step still done by hand.

Verified byte-for-byte: ImageMagick's own DDS writer (`convert -define
dds:compression=dxt1 -define dds:mipmaps=13`) produces a 128-byte DDS header
IDENTICAL to the game's original overview.dds, including the "IMAGEMAGICK"
tag baked into the reserved header bytes -- the original file was built the
same way. The only per-file difference between overview.dds and
overview-satellite.dds is the header's `depth` field (0 vs 1, otherwise
unused for a 2D texture) -- ImageMagick always writes 0, so the satellite
copy gets that single field binary-patched after conversion.

Usage:
  python3 build_dds.py <mod_root> [pda_output.png]

Requires ImageMagick's `convert` on PATH.
"""
import os
import struct
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))

MIP_LEVELS = 13  # 4096 -> 1, matches the game's own overview.dds exactly
DEPTH_FIELD_OFFSET = 24  # byte offset of the DDS header's `depth` field


def convert_to_dds(src_png, out_dds):
    subprocess.run(
        [
            "convert", src_png,
            "-define", "dds:compression=dxt1",
            "-define", "dds:mipmaps=" + str(MIP_LEVELS),
            out_dds,
        ],
        check=True,
    )


def patch_depth_field(dds_path, depth_value):
    with open(dds_path, "r+b") as f:
        f.seek(DEPTH_FIELD_OFFSET)
        f.write(struct.pack("<I", depth_value))


def verify_header(dds_path, expected_depth):
    with open(dds_path, "rb") as f:
        data = f.read(128)
    if data[:4] != b"DDS ":
        raise SystemExit(f"{dds_path}: not a DDS file (bad magic)")
    size, flags, height, width, pitch, depth, mips = struct.unpack("<7I", data[4:32])
    fourcc = data[84:88]
    if (width, height, mips, fourcc) != (4096, 4096, MIP_LEVELS, b"DXT1"):
        raise SystemExit(
            f"{dds_path}: unexpected header (w={width} h={height} "
            f"mips={mips} fourcc={fourcc!r})"
        )
    if depth != expected_depth:
        raise SystemExit(f"{dds_path}: depth={depth}, expected {expected_depth}")
    print(f"  {os.path.basename(dds_path)}: {width}x{height}, {mips} mips, "
          f"depth={depth}, {os.path.getsize(dds_path):,} bytes -- OK")


def main():
    mod_root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "..", "..")
    src_png = sys.argv[2] if len(sys.argv) > 2 else os.path.join(HERE, "pda_output.png")

    if not os.path.exists(src_png):
        raise SystemExit(f"source image not found: {src_png}")

    map_dir = os.path.join(mod_root, "map")
    overview_path = os.path.join(map_dir, "overview.dds")
    satellite_path = os.path.join(map_dir, "overview-satellite.dds")

    # overview.dds: depth=0, matches the game's original exactly.
    convert_to_dds(src_png, overview_path)

    # overview-satellite.dds: same rendered content (this project has no
    # separate satellite-style source), depth=1 to match the original file's
    # header -- reused rather than re-derived since ImageMagick's own output
    # is otherwise byte-identical to the stock asset either way.
    convert_to_dds(src_png, satellite_path)
    patch_depth_field(satellite_path, 1)

    print("verifying headers:")
    verify_header(overview_path, expected_depth=0)
    verify_header(satellite_path, expected_depth=1)
    print("done.")


if __name__ == "__main__":
    main()

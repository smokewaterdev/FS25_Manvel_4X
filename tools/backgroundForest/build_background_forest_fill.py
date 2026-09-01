#!/usr/bin/env python3
"""
Fill gaps in the background (outside-map_bounds) forest scatter with new
individually-placed trees, written as a standalone TransformGroup in
map/map.i3d ("backgroundForestFill") -- kept separate from the original
"forest" group so it can be identified, tweaked, or regenerated on its own.

Why this exists: Manvel's ~24k background/foreground trees were baked in by
the original maps4fs export with no saved builder script. Comparing the OSM
forest polygons (tools/pda/sources/osm_features.json, which cover the full
8192m DTM export box) against where those baked-in trees actually landed
showed several real-world forest patches outside the +-2048 playable square
with zero or very sparse tree coverage -- visible as the flat satellite
photo poking through past the map_bounds wall. This script fills those
gaps, sampling species/stage/scale from the existing tree population so new
trees blend in, and interpolating ground height (Y) from nearby existing
trees via inverse-distance weighting (there's no accessible heightmap data
for the area beyond the 4097x4097 dem.png, which only covers the playable
square).

Hard constraint: every generated point is clipped to strictly outside the
+-2048 box. This script only decorates the area beyond map_bounds -- it
never adds trees inside the playable/farmable area.

Usage:
  python3 build_background_forest_fill.py [mod_root] [--spacing 9] [--gap-radius 8]

Then either open map.i3d in GE (it's plain text, so this can run standalone
and the result just needs a GE re-save to regenerate terrain/collision
caches), or re-run and manually splice the output block back in following
the same insertion point used originally (right after the existing "forest"
TransformGroup's closing tag in map/map.i3d's <Scene>).

Regenerating: this script does NOT touch map.i3d directly on repeat runs by
default -- see main() -- it prints the block to stdout. To actually re-apply,
you need to first remove the existing "backgroundForestFill" TransformGroup
by hand (or add that as a --replace flag if you extend this).
"""
import argparse
import json
import os
import random
import re
from collections import Counter

import numpy as np
from matplotlib.path import Path
from scipy.spatial import cKDTree

HERE = os.path.dirname(os.path.abspath(__file__))

# The 23 OSM forest polygon indices (into sources/osm_features.json's
# "forest" list) identified 2026-08-31 as extending outside +-2048 with
# little/no existing tree coverage. Re-derive this list (see
# find_gap_polygons() below) if the map's placed-tree population changes.
EMPTY_IDXS = {43, 49, 83, 84, 85, 86, 87}
SPARSE_IDXS = {52, 77, 48, 42, 0, 41, 44, 13, 82, 12, 51, 3, 67, 80, 50, 46}


def load_existing_trees(map_i3d_path, group_name="forest"):
    content = open(map_i3d_path, encoding="utf-8").read()
    m = re.search(rf'<TransformGroup name="{group_name}".*?</TransformGroup>', content, re.S)
    if not m:
        raise SystemExit(f"could not find TransformGroup '{group_name}' in {map_i3d_path}")
    block = m.group(0)
    lines = re.findall(r"<ReferenceNode [^/]+/>", block)
    attr_re = re.compile(r'(\w+)="([^"]*)"')
    recs = []
    for l in lines:
        attrs = dict(attr_re.findall(l))
        tx, ty, tz = map(float, attrs["translation"].split())
        recs.append({"name": attrs["name"], "x": tx, "y": ty, "z": tz, "referenceId": attrs["referenceId"]})
    return recs, content, m.end()


def find_gap_polygons(forest_polys, existing_xz, bound=2048, cover_radius=15, empty_thresh=0.0, sparse_thresh=0.5):
    """Recompute which forest polygon indices extend outside `bound` and how
    covered they already are, using the same sampling approach used to
    originally derive EMPTY_IDXS / SPARSE_IDXS. Useful if the existing tree
    population changes and the hardcoded index sets need refreshing."""
    kd = cKDTree(existing_xz)
    empty, sparse = set(), set()
    for i, f in enumerate(forest_polys):
        pts = np.array(f["pts"])
        minx, minz = pts.min(axis=0)
        maxx, maxz = pts.max(axis=0)
        if maxx <= bound and minx >= -bound and maxz <= bound and minz >= -bound:
            continue  # fully inside playable bounds, not our concern
        gx = np.linspace(minx, maxx, 8)
        gz = np.linspace(minz, maxz, 8)
        gxx, gzz = np.meshgrid(gx, gz)
        sample = np.stack([gxx.ravel(), gzz.ravel()], axis=1)
        dists, _ = kd.query(sample, k=1)
        cov = (dists < cover_radius).mean()
        if cov <= empty_thresh:
            empty.add(i)
        elif cov < sparse_thresh:
            sparse.add(i)
    return empty, sparse


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("mod_root", nargs="?", default=os.path.join(HERE, "..", ".."))
    ap.add_argument("--spacing", type=float, default=9.0, help="grid spacing in meters between candidate trees")
    ap.add_argument("--gap-radius", type=float, default=8.0, help="skip candidates within this many meters of an existing tree (sparse polys only)")
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument("--start-node-id", type=int, default=200000)
    ap.add_argument("--group-name", default="backgroundForestFill")
    args = ap.parse_args()

    random.seed(args.seed)
    np.random.seed(args.seed)

    map_i3d = os.path.join(args.mod_root, "map", "map.i3d")
    osm_features_path = os.path.join(HERE, "..", "pda", "sources", "osm_features.json")

    recs, _, _ = load_existing_trees(map_i3d)
    xz_all = np.array([[r["x"], r["z"]] for r in recs])
    ys_all = np.array([r["y"] for r in recs])
    kd_all = cKDTree(xz_all)

    pool = Counter((r["name"], r["referenceId"]) for r in recs)
    pool_items = list(pool.items())
    pool_weights = np.array([c for (_, c) in pool_items], dtype=float)
    pool_weights /= pool_weights.sum()

    def sample_species():
        idx = np.random.choice(len(pool_items), p=pool_weights)
        (name, rid), _ = pool_items[idx]
        return name, rid

    def idw_y(x, z, k=6):
        dists, idxs = kd_all.query([x, z], k=k)
        dists = np.maximum(dists, 0.5)
        w = 1.0 / (dists ** 2)
        return float(np.sum(w * ys_all[idxs]) / np.sum(w))

    forest = json.load(open(osm_features_path))["forest"]
    target_idxs = sorted(EMPTY_IDXS | SPARSE_IDXS)

    lines = [f'    <TransformGroup name="{args.group_name}" translation="0 20 0" nodeId="{args.start_node_id - 1}">']
    next_id = args.start_node_id
    total = 0
    for i in target_idxs:
        pts = forest[i]["pts"]
        path = Path(pts)
        pts_arr = np.array(pts)
        minx, minz = pts_arr.min(axis=0)
        maxx, maxz = pts_arr.max(axis=0)
        gx = np.arange(minx, maxx + args.spacing, args.spacing)
        gz = np.arange(minz, maxz + args.spacing, args.spacing)
        gxx, gzz = np.meshgrid(gx, gz)
        cand = np.stack([gxx.ravel(), gzz.ravel()], axis=1)
        cand += (np.random.rand(*cand.shape) - 0.5) * args.spacing * 0.8
        inside = cand[path.contains_points(cand)]
        outside_mask = (np.abs(inside[:, 0]) > 2048) | (np.abs(inside[:, 1]) > 2048)
        inside = inside[outside_mask]
        if i in SPARSE_IDXS and len(inside):
            dists, _ = kd_all.query(inside, k=1)
            inside = inside[dists > args.gap_radius]
        for x, z in inside:
            y = idw_y(x, z)
            rot = round(random.uniform(0, 360), 3)
            scale = round(random.uniform(0.88, 1.12), 4)
            name, rid = sample_species()
            lines.append(
                f'      <ReferenceNode name="{name}" translation="{x:.3f} {y:.3f} {z:.3f}" '
                f'rotation="0 {rot} 0" scale="{scale} {scale} {scale}" referenceId="{rid}" nodeId="{next_id}"/>'
            )
            next_id += 1
            total += 1
    lines.append("    </TransformGroup>")

    print("\n".join(lines))
    import sys
    print(f"-- generated {total} trees, nodeIds {args.start_node_id}..{next_id - 1} --", file=sys.stderr)


if __name__ == "__main__":
    main()

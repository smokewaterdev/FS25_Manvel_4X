#!/usr/bin/env python3
"""
Parse the GE-exported road spline CSVs (map/CSVdata3/*_CSVdata.txt, produced
by the "Spline CSV Creator Panel OBJ_25" GE script) into map-local meter
point lists, cached as sources/ingame_roads.json.

These are the REAL built road splines from map.i3d's roadSystem group (10
primaryRoad + 3 secondaryRoad segments) -- actual in-game geometry, not
traced from real-world OSM data. OSM has no primary/secondary-tagged roads
in this area (see sources/osm_features.json: only motorway/tertiary/
unclassified/residential/service/track), so this is a new road layer added
on top of the OSM one, not a replacement of anything.

CSV line format (fixed by the exporter script): "zPos, xPos, height" per
line -- Z first, then X, then terrain height at that point. World meters,
same -2048..2048 convention as everything else in this project.

Run this again whenever you re-export the road CSVs from GE (new/changed
splines). compose_pda.py reads the cached JSON and never touches the raw
CSVs directly.

Usage:
  python3 build_ingame_roads.py [mod_root]
"""
import sys, os, json, glob

HERE = os.path.dirname(os.path.abspath(__file__))


def classify(filename):
    base = os.path.basename(filename)
    if base.startswith("primaryRoad"):
        return "primary"
    if base.startswith("secondaryRoad"):
        return "secondary"
    return None


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
            pts.append((round(x, 2), round(z, 2)))
    return pts


def main():
    mod_root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "..")
    csv_dir = os.path.join(mod_root, "map", "CSVdata3")

    roads = {"primary": [], "secondary": []}
    files = sorted(glob.glob(os.path.join(csv_dir, "*_CSVdata.txt")))
    if not files:
        print(f"no CSV files found in {csv_dir}")
        sys.exit(1)

    for path in files:
        kind = classify(path)
        if kind is None:
            print(f"skipping unrecognized file: {os.path.basename(path)}")
            continue
        pts = parse_csv(path)
        if len(pts) < 2:
            print(f"skipping {os.path.basename(path)}: only {len(pts)} point(s)")
            continue
        roads[kind].append({"name": os.path.basename(path).replace("_CSVdata.txt", ""), "pts": pts})
        print(f"{os.path.basename(path):32s} -> {kind:9s} {len(pts)} pts")

    os.makedirs(os.path.join(HERE, "sources"), exist_ok=True)
    out_path = os.path.join(HERE, "sources", "ingame_roads.json")
    with open(out_path, "w") as f:
        json.dump(roads, f)
    print(f"\nsaved {out_path}  (primary: {len(roads['primary'])} segments, secondary: {len(roads['secondary'])} segments)")


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""
Extract real field boundary polygons straight from map/map.i3d (the source
of truth), caching them as sources/field_polygons.json.

This is the actual per-field geometry, NOT the farmland raster
(infoLayer_farmlands.png) the old compose_pda.py used -- farmland
footprints are ownership parcels and don't always match individual field
shapes 1:1. Using the real field polygons is what PDA_MAP_NOTES.md flagged
as the more correct source.

Structure in map.i3d (regex-scanned rather than DOM-parsed -- the file is
too large to parse comfortably as a DOM):

  <TransformGroup name="fieldN" translation="fx 0 fz" nodeId="...">
    <TransformGroup name="polygonPoints" nodeId="...">
      <TransformGroup name="point1" translation="px 0 pz" nodeId="..."/>
      ...
    </TransformGroup>
    <TransformGroup name="nameIndicator" ...>
      <Note ... text="fieldN&#xA;NN.NN ha" .../>
    </TransformGroup>
    ...
  </TransformGroup>

World point = field translation + point translation (Y ignored, points are
already closed rings -- point1 == last point).

Usage:
  python3 build_fields.py [mod_root]
"""
import sys, os, re, json

HERE = os.path.dirname(os.path.abspath(__file__))

FIELD_HEADER_RE = re.compile(
    r'<TransformGroup name="field(\d+)" translation="([^"]+)" nodeId="(\d+)">'
)
POINT_RE = re.compile(
    r'<TransformGroup name="point\d+" translation="([^"]+)"'
)
HA_RE = re.compile(r'text="field\d+&#xA;([\d.]+) ha"')


def main():
    mod_root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "..", "..")
    i3d_path = os.path.join(mod_root, "map", "map.i3d")

    with open(i3d_path, encoding="utf-8") as f:
        text = f.read()

    headers = list(FIELD_HEADER_RE.finditer(text))
    if not headers:
        print(f"no field TransformGroups found in {i3d_path}")
        sys.exit(1)

    fields = []
    for i, m in enumerate(headers):
        field_num = m.group(1)
        fx, _fy, fz = (float(v) for v in m.group(2).split())
        block_start = m.end()
        # bound the search to just this field's polygonPoints block: it
        # always ends right before "nameIndicator" for this same field
        marker = text.find("nameIndicator", block_start)
        block_end = marker if marker != -1 else (
            headers[i + 1].start() if i + 1 < len(headers) else len(text)
        )
        block = text[block_start:block_end]

        pts = []
        for pm in POINT_RE.finditer(block):
            px, _py, pz = (float(v) for v in pm.group(1).split())
            pts.append((round(fx + px, 2), round(fz + pz, 2)))

        ha_m = HA_RE.search(text[block_start:block_start + 400] + text[marker:marker + 200] if marker != -1 else "")
        hectares = float(ha_m.group(1)) if ha_m else None

        if len(pts) < 3:
            print(f"field{field_num}: only {len(pts)} points, skipping")
            continue
        fields.append({"num": field_num, "pts": pts, "hectares": hectares})

    print(f"extracted {len(fields)} fields (of {len(headers)} field groups found)")

    os.makedirs(os.path.join(HERE, "sources"), exist_ok=True)
    out_path = os.path.join(HERE, "sources", "field_polygons.json")
    with open(out_path, "w") as f:
        json.dump(fields, f)
    print("saved", out_path)


if __name__ == "__main__":
    main()

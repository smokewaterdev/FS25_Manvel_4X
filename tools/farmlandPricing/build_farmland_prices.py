"""Derive farmlands.xml pricePerHa / priceScale from real soil data and real
2026 Grand Forks County, ND land-sale comps.

Rerun this whenever tools/soilMap/build_soil_map.py's CLASSES mapping changes,
or after any "hand-painted refinement" pass mentioned in tools/soilMap/README.md,
to regenerate map/config/farmlands.xml's pricing.

Method
------
1. Rasterize the SAME SSURGO source (tools/soilMap/ssurgo_mapunits.geojson) and
   CLASSES mapping used by build_soil_map.py, but over the FULL playable extent
   (FULL_WEST/SOUTH..FULL_EAST/NORTH) at 4096x4096 (1 m/pixel) instead of the
   quarter-area crop build_soil_map.py renders for the live PF soilMap.png.
   This is authoring-time only -- it does NOT touch map/data/soilMap.png or the
   compiled precisionFarming_soilMap.grle, so it has no effect on live PF yield
   sampling or existing saves' baked PF data.
2. Cross-tabulate against map/data/infoLayer_farmlands.png (also 4096x4096,
   1 m/pixel -- pixel value == farmland id, 255 == no farmland) to get each
   farmland's real soil-class mix.
3. Convert class mix to a priceScale using a 4-tier $/acre ladder anchored to
   real March 2026 Grand Forks County, ND auction comps (DTN Progressive
   Farmer): PI 58.8 tract sold at $3,000/ac, PI 88.9 at $9,500/ac. "Normal"
   (class 1, sandy loam) is pinned near the $6,500-6,800/ac blended average
   from that sale and NDSU Extension's ND cropland survey.

Price ladder ($/acre), and multiplier relative to the class-1 baseline:
    class 0 (loamy sand,  moderate limitation): $4,500/ac -> 0.692
    class 1 (sandy loam,  normal):              $6,500/ac -> 1.000  (baseline)
    class 2 (loam,        prime):               $9,000/ac -> 1.385
    class 3 (silty clay/water, strong limit):    $3,000/ac -> 0.462

pricePerHa is set so priceScale=1.0 == $6,500/ac exactly:
    16062 $/ha = $6,500/ac x 2.47105 ac/ha

Caveat: the SSURGO source polygons only densely cover part of the full extent
(~64% of pixels at time of writing) -- unrepresented pixels fall back to the
raster's default value 1 (normal). Farmlands 21, 25, 31, 32 are backed by
~100% real classified pixels; several others (ids with 0% real coverage,
printed below) are entirely on the default fallback and should be treated as
rough estimates pending a wider SSURGO pull or hand-painted refinement.
"""
from pathlib import Path
import json
import math
import re

from PIL import Image, ImageDraw
import numpy as np

REPO = Path(__file__).resolve().parents[2]
SOURCE = REPO / "tools" / "soilMap" / "ssurgo_mapunits.geojson"
FARMLANDS_PNG = REPO / "map" / "data" / "infoLayer_farmlands.png"
FARMLANDS_XML = REPO / "map" / "config" / "farmlands.xml"
SIZE = 4096  # matches infoLayer_farmlands.png, 1 m/pixel over the full playable extent

FULL_WEST, FULL_SOUTH = -97.1662471, 48.0588228
FULL_EAST, FULL_NORTH = -97.0559409, 48.1324952

# Same mapping as tools/soilMap/build_soil_map.py CLASSES.
CLASSES = {
    "2642511": 3, "2799686": 3,
    "2642538": 3, "2642582": 3, "2799639": 3, "2799668": 3,
    "2642581": 0, "2799637": 0, "2799711": 0,
    "2642540": 1, "2642567": 1, "2799698": 1, "2799703": 1,
    "2799706": 1, "2799718": 1,
    "2642597": 2, "2799636": 2, "2799709": 2, "2799710": 2,
    "2799715": 2, "2799719": 2, "2799720": 2,
}

CLASS_ACRE_PRICE = {0: 4500, 1: 6500, 2: 9000, 3: 3000}
BASE_ACRE_PRICE = CLASS_ACRE_PRICE[1]
CLASS_MULT = {c: round(p / BASE_ACRE_PRICE, 3) for c, p in CLASS_ACRE_PRICE.items()}
PRICE_PER_HA = round(BASE_ACRE_PRICE * 2.47105)


def mercator_y(lat):
    return math.log(math.tan(math.pi / 4 + math.radians(lat) / 2))


def rasterize():
    west, east = FULL_WEST, FULL_EAST
    south_y, north_y = mercator_y(FULL_SOUTH), mercator_y(FULL_NORTH)

    def point_to_pixel(pt):
        lon, lat = pt[:2]
        x = (lon - west) / (east - west) * SIZE
        y = (north_y - mercator_y(lat)) / (north_y - south_y) * SIZE
        return round(x), round(y)

    def iter_polygons(geom):
        if geom["type"] == "Polygon":
            yield geom["coordinates"]
        elif geom["type"] == "MultiPolygon":
            yield from geom["coordinates"]

    data = json.loads(SOURCE.read_text(encoding="utf-8"))
    soil = Image.new("L", (SIZE, SIZE), 1)  # default fallback: class 1 (normal)
    coverage = Image.new("1", (SIZE, SIZE), 0)

    for feature in data["features"]:
        mukey = str(feature["properties"]["mukey"])
        cls = CLASSES[mukey]
        for polygon in iter_polygons(feature["geometry"]):
            mask = Image.new("1", (SIZE, SIZE), 0)
            draw = ImageDraw.Draw(mask)
            draw.polygon([point_to_pixel(p) for p in polygon[0]], fill=1)
            for hole in polygon[1:]:
                draw.polygon([point_to_pixel(p) for p in hole], fill=0)
            soil.paste(cls, mask=mask)
            coverage.paste(1, mask=mask)

    return np.array(soil), np.array(coverage)


def compute_scales():
    soil, coverage = rasterize()
    farm = np.array(Image.open(FARMLANDS_PNG))
    assert farm.shape == soil.shape, "farmlands/soil raster resolution mismatch"

    scales, real_coverage = {}, {}
    for fid in sorted(set(np.unique(farm).tolist()) - {255}):
        m = farm == fid
        n = int(m.sum())
        if n == 0:
            continue
        classes = soil[m]
        frac = {c: (classes == c).sum() / n for c in range(4)}
        scales[int(fid)] = round(sum(frac[c] * CLASS_MULT[c] for c in range(4)), 3)
        real_coverage[int(fid)] = round(100 * coverage[m].mean(), 1)
    return scales, real_coverage


def write_farmlands_xml(scales):
    orig = FARMLANDS_XML.read_text(encoding="utf-8")
    out = []
    for line in orig.splitlines():
        m = re.match(r'(\s*<farmland id="(\d+)"\s+priceScale=")([\d.]+)("(.*)/>\s*)$', line)
        if not m:
            out.append(line)
            continue
        prefix, fid, _old_scale, suffix, _rest = m.groups()
        new_scale = scales.get(int(fid), 1)
        scale_str = "1" if new_scale == 1 else f"{new_scale:.3f}".rstrip("0").rstrip(".")
        out.append(f"{prefix}{scale_str}{suffix}")
    new_xml = "\n".join(out)
    new_xml = re.sub(r'pricePerHa="\d+"', f'pricePerHa="{PRICE_PER_HA}"', new_xml)
    FARMLANDS_XML.write_text(new_xml, encoding="utf-8")


if __name__ == "__main__":
    scales, real_coverage = compute_scales()
    print(f"pricePerHa = {PRICE_PER_HA} (${BASE_ACRE_PRICE}/ac at priceScale=1.0)")
    print(f"class multipliers: {CLASS_MULT}")
    low_confidence = [fid for fid, pct in real_coverage.items() if pct < 50]
    print(f"{len(scales)} farmlands scaled; {len(low_confidence)} below 50% real SSURGO coverage: {low_confidence}")
    write_farmlands_xml(scales)
    print(f"Wrote {FARMLANDS_XML}")

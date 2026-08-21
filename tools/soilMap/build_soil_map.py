from pathlib import Path
import collections
import json
import math
from PIL import Image, ImageDraw

REPO = Path(__file__).resolve().parents[2]
SOURCE = Path(__file__).with_name("ssurgo_mapunits.geojson")
SIZE = 2048

# The central playable half of the recorded 8192 m MapToPlay source extent.
FULL_WEST, FULL_SOUTH = -97.1662471, 48.0588228
FULL_EAST, FULL_NORTH = -97.0559409, 48.1324952
CENTER_LON, CENTER_LAT = -97.11109399999998, 48.09429

# Precision Farming pixel values:
# 0 loamy sand = moderate limitation; 1 sandy loam = normal productivity;
# 2 loam = prime productivity; 3 silty clay = strong wet/flood limitation.
CLASSES = {
    "2642511": 3, "2799686": 3,  # water
    "2642538": 3, "2642582": 3, "2799639": 3, "2799668": 3,
    "2642581": 0, "2799637": 0, "2799711": 0,
    "2642540": 1, "2642567": 1, "2799698": 1, "2799703": 1,
    "2799706": 1, "2799718": 1,
    "2642597": 2, "2799636": 2, "2799709": 2, "2799710": 2,
    "2799715": 2, "2799719": 2, "2799720": 2,
}


def mercator_y(latitude: float) -> float:
    radians = math.radians(latitude)
    return math.log(math.tan(math.pi / 4 + radians / 2))


def inverse_mercator_y(value: float) -> float:
    return math.degrees(2 * math.atan(math.exp(value)) - math.pi / 2)


def iter_polygons(geometry: dict):
    if geometry["type"] == "Polygon":
        yield geometry["coordinates"]
    elif geometry["type"] == "MultiPolygon":
        yield from geometry["coordinates"]
    else:
        raise ValueError(f"Unsupported geometry: {geometry['type']}")


half_lon_span = (FULL_EAST - FULL_WEST) / 4
west, east = CENTER_LON - half_lon_span, CENTER_LON + half_lon_span
full_y_span = mercator_y(FULL_NORTH) - mercator_y(FULL_SOUTH)
center_y = mercator_y(CENTER_LAT)
south_y, north_y = center_y - full_y_span / 4, center_y + full_y_span / 4
south, north = inverse_mercator_y(south_y), inverse_mercator_y(north_y)


def point_to_pixel(point):
    longitude, latitude = point[:2]
    x = (longitude - west) / (east - west) * SIZE
    y = (north_y - mercator_y(latitude)) / (north_y - south_y) * SIZE
    return round(x), round(y)


data = json.loads(SOURCE.read_text(encoding="utf-8"))
soil = Image.new("L", (SIZE, SIZE), 1)
coverage = Image.new("1", (SIZE, SIZE), 0)
seen = set()

for feature in data["features"]:
    mukey = str(feature["properties"]["mukey"])
    seen.add(mukey)
    for polygon in iter_polygons(feature["geometry"]):
        mask = Image.new("1", (SIZE, SIZE), 0)
        draw = ImageDraw.Draw(mask)
        draw.polygon([point_to_pixel(point) for point in polygon[0]], fill=1)
        for hole in polygon[1:]:
            draw.polygon([point_to_pixel(point) for point in hole], fill=0)
        soil.paste(CLASSES[mukey], mask=mask)
        coverage.paste(1, mask=mask)

unclassified = seen - CLASSES.keys()
if unclassified:
    raise ValueError(f"Unclassified MUKEY values: {sorted(unclassified)}")
if 0 in coverage.getextrema():
    raise ValueError("SSURGO coverage does not fill the playable raster")

output = REPO / "map" / "data" / "soilMap.png"
soil.save(output, format="PNG", compress_level=9)

palette = [(225, 202, 112), (126, 174, 105), (92, 161, 194), (164, 113, 166)]
preview = Image.new("RGB", soil.size)
preview.putdata([palette[value] for value in soil.getdata()])
preview.save(Path(__file__).with_name("soilMap_preview.png"), format="PNG", compress_level=9)

counts = collections.Counter(soil.getdata())
print(f"WGS84 bounds: {west:.7f},{south:.7f} to {east:.7f},{north:.7f}")
for value in range(4):
    print(f"class {value}: {counts[value] / (SIZE * SIZE):.2%}")
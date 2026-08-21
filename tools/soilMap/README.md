# Manvel Precision Farming soil-map source

The first-pass `map/data/soilMap.png` is a 2048 x 2048, 8-bit USDA SSURGO raster for the playable Manvel footprint.

- Map center: 48.09429, -97.111094
- Playable WGS84 bounds: -97.1386705, 48.0758681 to -97.0835174, 48.1127053
- Spatial source: USDA NRCS `cg_soils` MUPolygon ArcGIS service, downloaded 2026-08-21
- Attribute source: USDA Soil Data Access `Tabular/post.rest`, downloaded 2026-08-21
- Source survey areas: ND035 and MN119

PF values are management classes rather than literal texture labels:

- `0`: moderate limitation (mixed poor drainage, salinity inclusion, or steep/flood-prone unit)
- `1`: normal productive ground
- `2`: prime well/moderately drained silt-loam and levee ground
- `3`: strong wet, hydric, channeled, frequently flooded, or water unit

Run `build_soil_map.py` with Python and Pillow to rebuild the game raster and `tools/soilMap/soilMap_preview.png`. Adjust the `CLASSES` dictionary to tune whole SSURGO map units. Microtopographic and hand-painted refinements are intentionally deferred until the first in-game PF review.
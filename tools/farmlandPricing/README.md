# Manvel farmland pricing source

`build_farmland_prices.py` derives `map/config/farmlands.xml`'s `pricePerHa`
and per-farmland `priceScale` from the same SSURGO soil classification used
by `tools/soilMap/build_soil_map.py`, and from real 2026 Grand Forks County,
ND land-sale comps (see the script's docstring for the sources and math).

It rasterizes the SSURGO source over the *full* playable extent (rather than
the quarter-area crop the live PF `soilMap.png` uses) purely to compute
pricing — it never touches `map/data/soilMap.png` or the compiled
`precisionFarming_soilMap.grle`, so it has no effect on live PF yield
sampling or existing saves' baked PF data.

Rerun with `python3 build_farmland_prices.py` (needs Pillow + numpy) whenever:

- `tools/soilMap/build_soil_map.py`'s `CLASSES` mapping changes, or
- the soil map gets a hand-painted refinement pass (per
  `tools/soilMap/README.md`), or
- the real-world comp prices baked into `CLASS_ACRE_PRICE` should be updated.

As of the 2026-08-22 run, 19 of the 51 priced farmlands sit below 50% real
SSURGO pixel coverage (the rest of their area falls back to the raster's
default "normal" class because the source SSURGO polygons don't densely
tile the full playable extent) — treat those as rough estimates. Farmlands
21, 25, 31, and 32 are backed by ~100% real classified data.

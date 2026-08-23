# PDA sample map — composite sources

This folder holds the reusable pieces used to generate `pda_output.png`, a
sample farmland/overview map styled to look like the in-game PDA (flat tan
hatched fields, forest, roads, water — no farmland number labels, since the
game adds those itself).

The goal is to avoid re-deriving everything from scratch every time you want
an updated render: the expensive, one-time part (parsing `manvel.osm`,
calibrating real-world lat/lon to the map's local meter coordinates) is
cached in `sources/`. Regenerating the image after you've edited fields is
just re-running `compose_pda.py`, which reads the live farmland raster plus
the cached OSM data.

## Files

- **`sources/calibration.json`** — the exact math used to convert OSM
  lat/lon into this map's local X/Z meters (origin, scale, axis sign), plus
  notes on how it was derived and validated.
- **`sources/calibration_check.png`** — the validation image: real OSM
  `landuse=farmland` polygons (red) overlaid on this project's own known
  field geometry (blue). They line up almost exactly, which is what confirms
  the calibration is correct.
- **`sources/osm_features.json`** — every relevant feature from `manvel.osm`
  (roads, forest polygons, tree rows/shelterbelts, water polygons, streams
  and ditches), already projected into local meters. This is the cache —
  `compose_pda.py` never re-parses the raw `.osm` file. Covers
  motorway/tertiary/unclassified/residential/service/track — OSM has nothing
  tagged primary/secondary in this area.
- **`extract_osm_sources.py`** — the script that builds
  `sources/osm_features.json` and `sources/calibration.json` from
  `../manvel.osm`. Only needs to be re-run if you edit/re-trace
  `manvel.osm` in JOSM (add a road, fix the river course, etc.). Real-world
  geography doesn't change, so this should rarely need to run again.
- **`sources/ingame_roads.json`** — the real built primary/secondary road
  splines from `map.i3d`'s `roadSystem` group (10 primary + 3 secondary
  segments), not OSM-traced. This is the cache — `compose_pda.py` never
  re-parses the raw CSVs.
- **`build_ingame_roads.py`** — the script that builds
  `sources/ingame_roads.json` from `../map/CSVdata3/*_CSVdata.txt`. Those
  CSVs come from GE: select each `roadSystem` spline and run the "Spline CSV
  Creator Panel OBJ_25" script (Scripts menu) to export it. Re-run this (and
  re-export the CSVs in GE first) whenever the road splines change shape.
- **`compose_pda.py`** — regenerates `pda_output.png`. Reads the cached OSM
  sources and in-game road sources (static) plus
  `../map/data/infoLayer_farmlands.png` (live — this is what changes every
  time you edit fields/farmlands in GE). Takes a few seconds; no network
  access needed.
- **`pda_output.png`** — the current rendered sample, at native 4096×4096.

## Regenerating after a field/farmland edit

```
cd pda
python3 compose_pda.py
```

Optionally pass the mod root and an output path explicitly:

```
python3 compose_pda.py "C:\path\to\FS25_Manvel_4X" pda_output.png
```

## Regenerating after editing manvel.osm

```
cd pda
python3 extract_osm_sources.py   # rebuilds sources/osm_features.json
python3 compose_pda.py           # re-renders the image
```

## Regenerating after changing the primary/secondary road splines

1. In GE, select each `roadSystem` spline (primaryRoadNN / secondaryRoadNN)
   and run the "Spline CSV Creator Panel OBJ_25" script to (re-)export its
   CSV into `map/CSVdata3/`.
2. Then:

```
cd pda
python3 build_ingame_roads.py    # rebuilds sources/ingame_roads.json
python3 compose_pda.py           # re-renders the image
```

## Style notes / what's NOT in here

- No farmland ID numbers — the in-game PDA adds those.
- Field fill is a flat tan base with a diagonal hatch to suggest plowed
  furrows; it doesn't try to match each field's actual tillage direction.
- Roads are drawn with a fixed width per OSM highway class (motorway wider,
  service/track narrower), not measured from real lane widths.
- This is a **stylistic sample**, not the actual in-game `overview.dds` /
  `overview-satellite.dds` asset. Turning it into that real game asset is a
  separate, bigger step — see `../PDA_MAP_NOTES.md`.

# PDA / overview map generator

This folder generates `map/overview.dds` (and `overview-satellite.dds`'s
companion background) — the actual image the game shows on the in-game
map/PDA screen. This is no longer a "someday" project or a stylistic
preview: the pipeline here is what produced the currently-deployed
`overview.dds`.

If you're looking for **why** the render has to be built the way it is
(an 8192m context canvas with the 4096m playable square inset at the
center, not a simple 1:1 render), see "The context-canvas thing" near the
bottom — that's the fix for the "twice as big" bug from earlier.

## Quick start: regenerate and deploy from scratch

```
cd tools/pda
python3 build_pda_v2.py .. 5 pda_output.png
```

Stage `5` is the full render (water + forest + fields + farmyards +
roads — see `build_pda_v2.py`'s own `--help`-style docstring for what
stages 1-4 isolate, useful for debugging one layer at a time).

That reads everything from the `sources/` cache — it does **not** touch
`manvel.osm`, GE, or any live map data unless you've changed something (see
the table below for when to rerun an earlier step first).

Converting `pda_output.png` into the actual `map/overview.dds` is the one
step that doesn't have a saved script yet (see "DDS packaging" below) — it
was done as one-off work this session. Worth writing up as a real script
if you expect to regenerate this more than once or twice more.

## Pipeline order

Each step caches its output in `sources/`, so you only need to rerun the
steps whose *input* actually changed — `build_pda_v2.py` always reads
from the cache, never from live map/OSM data directly.

| If you changed...                              | Rerun this first                    | Then |
|--------------------------------------------------|--------------------------------------|------|
| `manvel.osm` (re-traced something in JOSM)        | `python3 extract_osm_sources.py`     | `build_pda_v2.py` |
| Fields (moved/added/removed in GE)                | `python3 build_fields.py`            | `build_pda_v2.py` |
| Terrain forest ground textures                    | `python3 build_forest_mask.py`       | `build_pda_v2.py` |
| Terrain heightmap / river course                  | `python3 build_water_mask.py`        | `build_pda_v2.py` |
| Any road (paved with gravel texture) added/moved  | `python3 build_road_mask.py`         | `build_pda_v2.py` |
| Primary/secondary road **splines** reshaped        | re-export CSVs in GE (see below), then `python3 build_ingame_roads.py` | `build_pda_v2.py` |

All of these take `<mod_root>` as their first argument (default: `..`,
i.e. this script assumes it's sitting in `<mod_root>/tools/pda`).

### Re-exporting road spline CSVs (only needed if you reshape the splines)

`build_ingame_roads.py` reads `map/CSVdata3/*_CSVdata.txt`. That folder
isn't kept in the repo (the exports are regenerable, and the cached
`sources/ingame_roads.json` is what actually gets used day to day), so if
you need to rebuild it from scratch:

1. In GE, select each `roadSystem` spline (`primaryRoadNN` /
   `secondaryRoadNN`) and run the **"Spline CSV Creator Panel OBJ_25"**
   script (Scripts menu) to export its CSV into `map/CSVdata3/`.
2. `python3 build_ingame_roads.py`

### DDS packaging (no saved script yet)

The final step — converting `pda_output.png` into `map/overview.dds` —
needs to match the game's own texture format: DXT1-compressed, 4096×4096,
13 mip levels, same DDS header layout as the original `overview.dds`
(verified byte-for-byte against the stock file, aside from one unused
`depth` field). This was done inline as one-off work rather than saved as
a script here. If you're going to touch the PDA again, it's worth turning
that into a proper `build_dds.py` so this whole pipeline is a single
command from `manvel.osm`/live map data all the way to a deployable
`map/overview.dds`.

## What's in this folder

- **`extract_osm_sources.py`** — parses `../manvel.osm`, projects every
  relevant feature (roads, forest, tree rows, water, waterways) into the
  map's local meter coordinates. Caches `sources/osm_features.json` and
  `sources/calibration.json` (the lat/lon → local-meters math, plus how it
  was validated). Covers the full 8192m context box, not just the 4096m
  playable square — see "The context-canvas thing" below for why that
  matters.
- **`build_fields.py`** — extracts real field boundary polygons straight
  from `../map/map.i3d` (the source of truth — not the farmland raster,
  which is ownership parcels and doesn't always match field shapes 1:1).
  Caches `sources/field_polygons.json`.
- **`build_forest_mask.py`** — builds the forest mask straight from the
  live terrain's own ground-texture weight maps (forestGrass, forestLeaves,
  forestNeedels, rockForest, etc. — whatever texture the game actually
  paints as forest), not from the OSM trace. Caches `sources/forest_mask.png`.
- **`build_water_mask.py`** — builds the water mask from the live terrain
  heightmap (`map/data/dem.png`)'s carved river channel, not from the OSM
  trace. Caches `sources/water_mask.png`.
- **`build_road_mask.py`** — builds the road mask from the live terrain's
  gravel texture layers (every road on this map — built splines and minor
  farm access alike — is painted with gravel, so this one mask replaces
  both the OSM road trace and the separate spline line-drawing with a
  single, drift-free source). Caches `sources/road_mask.png`. Also the
  fix for the seam and floating-circle mask artifacts (spline-corridor
  exclusion + small-skeleton-component filtering).
- **`build_ingame_roads.py`** — builds `sources/ingame_roads.json` from
  GE's exported primary/secondary spline CSVs (see above). Only needed
  again if the splines get reshaped.
- **`build_pda_v2.py`** — the actual composite renderer. Builds the 8192m
  context canvas, draws the inset 4096m playable square at 2x downscale,
  layers water → forest → fields → farmyards → roads from the cached
  masks/data, and writes `pda_output.png`. This is the current entry
  point — run it after any of the steps above that apply.
- **`sources/`** — the cache described above, plus
  `sources/calibration_check.png` (validation image: OSM `landuse=farmland`
  polygons overlaid on this project's own known field geometry, confirming
  the lat/lon calibration is correct).
- **`pda_output.png`** — the current rendered source image, native
  4096×4096, ready to be packaged into `map/overview.dds`.
- **`compose_pda.py`** — the original, simpler renderer this project
  started from (OSM-only fields, no live masks, no context canvas). Fully
  superseded by `build_pda_v2.py` — kept only for reference, not part of
  the regeneration path above.

## The context-canvas thing

`overview.dds` does **not** show the 4096m playable square at 1:1 across
the whole 4096×4096 texture. Decoding the game's original file shows the
darker "playable area" tint sitting in the center **half** of the canvas
— i.e. the texture actually spans the full 8192m MapToPlay export box,
with the playable square inset in the middle at the same scale as the rest
(1 texture px = 2 world m throughout). Rendering at 1px = 1m across the
whole canvas — the original assumption — made every real feature draw at
exactly 2x the size the game expects, which is what showed up in-game as
the map looking "twice as big" as it should. `build_pda_v2.py`'s
`draw_context_background()` / `to_px_context()` are the fix: they draw the
full 8192m context first, then composite a 2x-downscaled version of the
4096m inner render into the center.

# Custom PDA / Farmland Map — Notes for Later

Status: deferred — revisit once field boundaries, farmland parcels, and the silo/barge decision are all finalized. Don't build the real asset off this until the underlying data (fields, farmlands) stops changing.

## Why this note exists

While debugging the field-boundary fix (trimming/deleting fields that hung over the map edge), a quick verification script produced a clean top-down rendering of all field polygons against the real map boundary — clean enough that it's worth turning into an actual in-game PDA / farmland overview image later, rather than throwing the script away.

## What the verification script actually did

1. **Pulled field geometry straight from the source of truth.** Field polygons aren't stored as a raster — each field is a `TransformGroup` object in `map/map.i3d` under the `fields` group, with a `polygonPoints` child holding sequential `pointN` nodes. Extracted with a regex pass over the raw XML (the file is too large to parse as a DOM comfortably): match `<TransformGroup name="fieldN" translation="fx fy fz" ...>`, then pull every nested `<TransformGroup name="pointN" translation="px 0 pz" .../>` and add the field's own translation to get world-space coordinates.

2. **Established the real map edge independently.** Rather than trust the field data or guess the terrain size, exported `map_bounds_walls` (the actual physical collision boundary) from GE as a Wavefront OBJ. GE's OBJ exporter scales coordinates ×100, so real world units = raw OBJ coords ÷ 100. That gave an exact, verified box: X and Z both -2048 to 2048.

3. **Calibrated the world→pixel mapping with a known ground-truth point.** The farmland info-layer raster (`infoLayer_farmlands.png`, 4096×4096) needed a coordinate transform to cross-reference against. Used the grain barge terminal (known to sit on farmland 60) as a calibration point and tested candidate transforms until one produced pixel value 60 exactly at that location. Result: `pixel = world_coordinate + 2048`, no axis flip — this matches the map_bounds box exactly (both span the same -2048..2048 range), confirming farmland ID assignment and field geometry live in the same coordinate space.

4. **Rendered with matplotlib**, not a game-side tool: field polygons as filled patches, the map_bounds box as a reference rectangle, before/after states overlaid in different colors (green = kept, red hatched = deleted) so the fix was visually self-evident without needing GE open or ground textures painted.

## What would actually be needed for a real PDA/overview asset

This was a debug plot, not the game's PDA renderer — the two are unrelated pipelines:

- The game's actual PDA farmland screen renders from `infoLayer_farmlands` (the GRLE raster + `farmlands.xml` for names/IDs), not from field polygons directly. A real "farmland map" background likely wants to be generated from that raster (color per farmland ID) rather than from the field polygon data this script used.
- The map's `overview.dds` and `overview-satellite.dds` files (in the map root, ~11MB DDS textures) are what the in-game map screen actually displays as the background — worth checking whether GIANTS Editor has a built-in "bake overview" script/tool before hand-building one, similar to how field-boundary rendering turned out to already have a built-in `Toggle Render Field Areas` script (Scripts menu, with `field.i3d`'s root already carrying the `FieldUtil.onCreate` callback it needs).
- Whatever we build should probably combine: the farmland raster (for accurate parcel shapes/colors/IDs) + field boundary outlines (for the tilled-line texture look players expect) + the barge/dealership/farmers-market special-purpose farmlands labeled distinctly from crop fields.

## Reusable pieces already on hand

- The field polygon extraction regex (works against `map/map.i3d` directly, no GE needed).
- The farmland raster world↔pixel calibration (`pixel = world + 2048`).
- `grleconvert` (community tool, MIT licensed, https://github.com/Paint-a-Farm/grleconvert) for converting `infoLayer_farmlands.png` ↔ `.grle` losslessly — already used and verified round-trip-clean for the farmland non-buyable and boundary-trim edits earlier in this project.

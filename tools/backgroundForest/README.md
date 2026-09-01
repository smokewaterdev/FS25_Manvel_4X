# Background forest fill

`build_background_forest_fill.py` fills gaps in the background (outside
`map_bounds`) tree scatter, using the real OSM forest polygons already
extracted for the PDA pipeline (`tools/pda/sources/osm_features.json`) as
ground truth for where forest actually exists in the real world.

## Why

Manvel's ~24k trees were baked into `map/map.i3d` by the original maps4fs
export, with no saved builder script. Comparing those placements against
the real-world forest polygons showed several patches beyond the playable
`+-2048` square with little or no tree coverage -- visible in-game as the
flat satellite-photo backdrop poking through past the boundary wall.

Added 2026-08-31: a first pass, `backgroundForestFill` (7,143 trees, node
IDs 200000-207142), covering 7 fully-empty and 16 sparsely-covered forest
polygons at ~9m spacing. Kept as its own `TransformGroup`, separate from
the original `forest` group, so it's easy to find, tweak, or regenerate
without touching the baked-in placements.

## Constraints

- Every generated point is clipped to strictly outside `+-2048` -- this
  never adds trees inside the playable/farmable area.
- Species, growth stage, and scale are sampled from the existing tree
  population's own distribution, so new trees match the established look
  (weighted random draw from the ~47 distinct species/stage combos already
  in use).
- Ground height (Y) is inverse-distance-weighted from the 6 nearest
  existing trees (by XZ distance) -- there's no accessible heightmap for
  the area beyond `map/data/dem.png`, which only covers the 4097x4097
  playable square. This works because the Red River Valley is genuinely
  flat; it would be a worse approximation on hillier terrain.

## Usage

```
cd tools/backgroundForest
python3 build_background_forest_fill.py .. --spacing 9 --gap-radius 8
```

Prints the `<TransformGroup>` XML block to stdout. To actually apply it,
splice it into `map/map.i3d` right after the existing `forest`
TransformGroup's closing tag (inside `<Scene>`), the same place the
2026-08-31 pass was inserted.

Options:
- `--spacing` — grid spacing in meters between candidate trees (default 9,
  chosen as a lighter alternative to the ~3.5m spacing of the original
  export, to keep node count sane for gap-fill purposes)
- `--gap-radius` — for sparsely-covered polygons, skip candidates within
  this many meters of an existing tree, so it only fills real gaps instead
  of doubling up (default 8)
- `--start-node-id` — first `nodeId` to use; must not collide with any
  existing `nodeId` in `map.i3d` (default 200000; the file's max was
  135939 as of 2026-08-31)
- `--group-name` — override the `TransformGroup` name if regenerating a
  second, distinctly-named pass

## Regenerating / extending

The 7 empty + 16 sparse polygon indices (`EMPTY_IDXS` / `SPARSE_IDXS` in
the script) were identified once by sampling each OSM forest polygon that
extends outside `+-2048` and checking tree density near a sampled grid
inside it. If the placed-tree population changes significantly, rerun
`find_gap_polygons()` (already in the script) to recompute those sets
rather than trusting the hardcoded ones.

Not yet covered: `osm_features.json`'s `tree_row` features (24 shelterbelt
lines) weren't included in this pass — only `forest` polygons. Shelterbelts
are a distinctive Red River Valley feature and would be a reasonable
follow-up if more background detail is wanted.

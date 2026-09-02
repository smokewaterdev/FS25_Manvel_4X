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

## Background terrain blend mask

`build_background_terrain_mask.py` generates
`assets/background_terrain/background_terrain_mask.png`, the blend mask
used by `background_terrain.i3d`'s material (swapped 2026-08-31 from a flat
single-texture material to the vanilla `backgroundTerrainShader`, the same
shader mapUS/mapEU/mapAS use for their own background rings). It blends a
grass texture in right at the `map_bounds` edge (fading out over 400m by
default) and a forest-floor texture wherever real OSM forest polygons are,
over the top of the existing satellite photo -- softens the "straight to a
photo" look and gives the new background trees (above) real-looking ground
to sit on, without touching the mesh geometry at all.

```
python3 build_background_terrain_mask.py .. --res 2048 --plateau 150 --fade 1500 --dilate 12
```

This assumes `background_terrain.dds` (8192x8192px) is a simple 1:1
world-aligned drape over world X,Z in `[-4096, 4096]`. That assumption
checked out 2026-08-31 -- a first pass confirmed the grass blend lands in
the right place (visible hugging the real map edge in a GE top-down view),
just too weak: a straight 400m linear fade from full strength at the
boundary spends most of its range at low opacity against a busy satellite
photo, so only a thin sliver actually reads as green in-game. Fixed by
holding full opacity for `--plateau` meters before the `--fade` taper
starts, so there's a real, clearly-visible solid band before it blends
out. `--fade` was widened from an initial 600m to 1500m by request.

The script's actual output that `background_terrain.i3d` references is
`background_terrain_mask.dds`, not the `.png` -- as of 2026-09-01 it packs
the PNG into a **DXT1 (BC1)** DDS with a full 12-level mip chain (matching
`background_terrain.dds`, its sibling in the same material) as its last
step. The `.png` is still written first and kept as the
human-editable/diffable source; only the `.dds` is consumed by the game.

It must be block-compressed, not raw. GIANTS' `Texture ... raw format.`
performance warning fires on *uncompressed* textures specifically. A first
attempt at this packed the mask uncompressed on the theory that DXT1's 4x4
blocks would band a smooth gradient; that was wrong on the trade -- it
turned a 23KB PNG into a 16.8MB raw texture and the warning still fired
three times in the GIANTS Editor console. DXT1 is ~2.8MB and silences it.
DXT1 rather than a single-channel format because the mask is genuinely
2-channel: R and G carry the two projected-grass blend weights
(`projDiffuse1`/`projDiffuse2`), B is unused.

An earlier version of this note claimed the un-mipped PNG caused a
multi-minute load hang on an Apple M3 Pro. That was wrong and is retracted
-- the hang reproduced with this texture in every state it has been in, and
also with the whole background terrain reverted. See CHANGELOG.md's "Load
time investigation" section for what was actually ruled out. This mip/format
change stands on its own as correct texture packaging, not as a fix for that.

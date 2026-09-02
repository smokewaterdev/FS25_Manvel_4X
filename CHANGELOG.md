# Changelog

All notable changes to Manvel 4X are documented here, newest first. Format is
based on [Keep a Changelog](https://keepachangelog.com/), adapted to the
4-part version number GIANTS itself uses (`major.minor.patch.build`, e.g.
`1.5.0.1`) instead of semver's 3-part scheme — see `BUILD.md` for the release
process this file feeds into.

## Version number convention

Bump whichever is the *highest* one a change qualifies for; reset everything
below it to `0`.

| Part  | Bump when...                                                        |
|-------|----------------------------------------------------------------------|
| major | A change breaks existing saves (removed/renumbered farmland, deleted field, moved a placeable's uniqueId) |
| minor | New content, save-compatible (new building, new field, new equipment) |
| patch | Bug fixes, balance/pricing tweaks, texture/mesh fixes — no new content |
| build | Anything else worth a tag: doc updates, dependency bumps, internal cleanup |

The number in this file's version headings must always match
`<version>` in `modDesc.xml` exactly — that's the field ModHub and the
in-game mod manager read to detect an update, and it only recognizes a
*higher* number as newer.

**Save compatibility** matters enough for a map mod that every entry below
should say, in plain language, whether an existing save is safe to continue
on the new version or needs a fresh start. Don't assume — call it out.

## [Unreleased]

Changes since `0.8.0.2` that haven't shipped in a tagged release yet. Move
this section's contents under a new version heading (and bump
`modDesc.xml`) when you cut the next release — see `BUILD.md`.

### Fixed
- `background_terrain.i3d`'s blend mask now loads as a DXT1-compressed DDS
  with a baked 12-level mip chain (`background_terrain_mask.dds`, 2.8MB)
  instead of a raw PNG. This supersedes an earlier attempt in this same
  unreleased window that produced an *uncompressed* DDS — that was wrong:
  GIANTS' `Texture ... raw format.` performance warning fires on
  uncompressed textures specifically, so the uncompressed version kept the
  warning firing (confirmed three times in the GIANTS Editor console) while
  inflating a 23KB PNG into a 16.8MB raw texture. DXT1 (RGB, no alpha) is
  the correct variant here: the mask carries the two projected-grass blend
  weights in R and G and leaves B unused.
  `tools/backgroundForest/build_background_terrain_mask.py` packs it
  automatically as its last step.

  Note the earlier entry also credited this texture as the likely cause of
  a multi-minute load hang on an Apple M3 Pro. That was wrong and is
  retracted — see "Load time investigation" below.

  **Save compatibility:** safe — texture format change only.

- Procedural placement rule `gen_river_ground` had `frequency="0.000000"`
  on its `scatterInPerlinNoise.lua` script. A Perlin scatter sampled at
  `position * 0` returns one constant value for the whole map, so the noise
  gate wasn't gating anything — the SAND scatter along `PG_river` was
  uniform rather than varying. Now `0.400000`, matching the sibling
  `gen_forest_foilage` rule.

  **Save compatibility:** safe — no scene graph, farmland, field or
  placeable changes. Riverbank sand distribution may look different.

### Changed
- Reverted the temporary diagnostic edits that were committed during the
  load-time investigation (commits `b38d805`, `fc321d9`, `925caa1`): both
  forest groups and the traffic system's `onCreate` UserAttribute are
  active again, the two river procedural placement rules are re-enabled,
  and `background_terrain` is back to its decimated mesh plus grass-blend
  custom shader. Map content is functionally back to its `0.8.0.2` state.

  **Save compatibility:** safe — restores previously shipped content.

### Load time investigation

A long load / apparent hang reproduced on an Apple M3 Pro (18GB unified
memory) but never on a Ryzen 9800X3D / RTX 5070 Ti desktop. Recorded here
because eliminating these cost a great deal of testing and none of them
should be re-tested without new evidence.

Ruled out, each by direct measurement:

- **Trees.** The map's 31,353 trees are not the cause. A run with both
  forest groups commented out (`NumTrees 0`) still took ~19 minutes, while
  the base game's Riverbend Springs — 13,174 trees — loaded on the same
  Mac, in the same process, ten minutes later, in 42 seconds.
- **Traffic system, background terrain mesh, background terrain shader,
  procedural placement.** Each disabled or reverted independently; no
  effect. Procedural placement in particular runs *inside* the `map.i3d`
  load, which completes in ~5s when the stall doesn't fire.
- **Row Crop System.** RCS creates all five of its 16384x16384 info layers
  in 14ms on the Mac — faster than the desktop's 77ms.
- **Rolling back weeks of commits.** No effect, which is itself the
  strongest evidence the cause was never in map content.
- **Lowering the Mac's graphics settings** (`game.xml` quality preset and
  view distance coefficients). No effect.

What the evidence actually shows: one large, *non-deterministic* stall that
lands at an arbitrary point in asset loading and moves between runs — 895s
between two tree files in one run, 703s between two placeable files in
another, and absent entirely in a third, all on identical content. Smaller
stalls (284s, 124s, 28s) appear at varying points in the same runs. The
`map.i3d` parse itself is 5,051ms on the Mac versus 5,157ms for the base
game map, so the map is not intrinsically slow to load; it stalls.

Still open. Next candidates are Mac-side and environmental rather than map
content: free disk space, and whether the unzipped 490MB / 395-file mod
folder is being read through a sync daemon (iCloud Desktop, external or
network volume). The base game map reads from the sealed app bundle
instead, which would explain why only Manvel is affected.

## [0.8.0.2] - 2026-09-01

### Fixed
- Added the missing `FS25_0_THRowCropSystem` ("[TH] Row Crop System")
  dependency to `modDesc.xml`. Manvel is built on and advertises the Row
  Crop System, but the mod itself was never declared as a dependency — it
  overwrites core sowing/harvest functions (`FSDensityMapUtil.updateSowingArea`,
  `getFruitArea`, `SowMission.getPartitionCompletion`, etc., confirmed by
  reading its actual source) to make row-crop planting behave like row-crop
  planting at all. Without it, the map's row-crop foliage/density-map data
  just sits there unused and planting behaves like a normal, non-row-crop
  map — silently, with no error, same failure mode as the earlier missing
  Precision Farming dependency.
- `modDesc.xml`'s dependency on `FS25_0_THPFConfigurator` updated to
  `FS25_0_TRPFConfigurator`. ThundR renamed the mod itself (now
  "[TR] Precision Farming Configurator") in v1.2.0.5 (August 2026) — the
  filename changed, XML config syntax didn't. Confirmed via a player's own
  `log.txt`: their mods folder had `FS25_0_TRPFConfigurator` (the current
  official download) available, but our old dependency string still
  demanded the retired `FS25_0_THPFConfigurator` name, so the game reported
  it missing even though the correct mod was installed. This was the real
  cause behind the "requires FS25_0_THPFConfigurator.zip" reports — not a
  filename mismatch on the player's end.

### Changed
- `README.md`'s "You'll also need" section and `modDesc.xml`'s in-game
  description both updated: now list seven required mods instead of six
  (adding Row Crop System), both pointing at ThundR's actual FS25 Downloads
  collection on Patreon, with a callout explaining the
  THPFConfigurator→TRPFConfigurator rename so anyone still holding an
  older download knows to delete it and grab the current
  `FS25_0_TRPFConfigurator.zip` instead.

**Save compatibility:** safe for existing saves once the correct mod files
are installed — these changes only affect which filenames `modDesc.xml`
looks for, nothing in the map itself. Players need
`FS25_0_TRPFConfigurator.zip` (not the old `THPFConfigurator` name) and
`FS25_0_THRowCropSystem.zip` both present in their mods folder before
loading.

## [0.8.0.1] - 2026-09-01

### Added
- Map-owned `PROPANE` fill type (`map/config/fillTypes.xml`), so the map no
  longer relies on a third-party mod to register it.
- `assets/manvelCoop/propaneBuyPoint.i3d` — a new propane buy point built
  entirely on the vanilla GIANTS `gasTankSet` prop that ships with the base
  game, replacing the one bundled with the `FS25_WesteelSiloSystem`
  dependency. It now shows two tanks (scaled 1.5x) instead of one, ringed
  by a safety-post perimeter built from the vanilla `fence10` post prop —
  matching the twin-tank-plus-fence layout the original mod's own asset
  used, just built on first-party geometry instead.

### Changed
- `assets/manvelCoop/propaneBuyPoint.xml` now points at the new local
  `.i3d`, uses a vanilla store icon, and updates its `i3dMappings` node
  paths to match the new scene hierarchy.
- `map/map.i3d`'s propane station reference now points at the new local
  asset instead of `FS25_WesteelSiloSystem/propaneBuyPoint.i3d`.

### Removed
- `FS25_WesteelSiloSystem` ("AGI Westeel Silo System") dependency from
  `modDesc.xml` and `README.md` — its ModHub listing is currently
  unreachable, which blocked new players from getting the map running at
  all ([#1](https://github.com/smokewaterdev/FS25_Manvel_4X/issues/1)).

**Save compatibility:** safe. The propane placeable's `uniqueId` in
`placeables.xml` is unchanged, so existing saves should pick up the new
asset in place without needing a fresh start.

### Fixed
- Added `FS25_precisionFarming` and `FS25_0_THPFConfigurator` to `modDesc.xml`'s
  `<dependencies>` (and updated the in-game description/README to match).
  Both were already wired up correctly in `map/map.xml`
  (`<thPFConfig>`/`<precisionFarming>`), but without the `modDesc.xml`
  entries, players who didn't happen to already have them installed got no
  prompt to grab them - Precision Farming and RCS silently didn't work for
  them. Manvel now requires six dependencies instead of four.

## [0.8.0.0]

Starting point — first version tracked in this changelog. Never published,
so no prior version history to reconcile against. When you cut the first
GitHub Release/tag, add the date to this heading (`[0.8.0.0] - YYYY-MM-DD`)
and move on to a fresh `[Unreleased]` section for whatever comes next.

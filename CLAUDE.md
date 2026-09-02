# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

A Farming Simulator 25 map mod (Manvel, ND — Row Crop System). `modDesc.xml`
is the entry point GIANTS reads. Most of the "code" here is data GIANTS
Editor (GE) authored — XML configs and `.i3d` scene files — not hand-written
logic. There is no application to run and no automated test suite; the only
way to validate a change is to open the relevant `.i3d` in GIANTS Editor (or
load the map in-game) and check the log/behavior directly.

The mod depends on five other ModHub mods that must be installed for the map
to load at all (declared in `modDesc.xml` `<dependencies>`): US Mailboxes,
Grain Silo System, AGI Westeel Silo System, Liquid Lime, Liquidstorage.

## Building a release

```
python tools/build_release.py           # writes releases/FS25_Manvel_4X.zip
python tools/build_release.py --version # + a version-tagged copy
python tools/build_release.py --list-only  # dry run, just prints what's included
```

Pure stdlib, run with any Python 3. `releases/` is gitignored — never commit
its output. Full release checklist (version bump, tag, GitHub Release,
push) is in `BUILD.md`. Update `CHANGELOG.md`'s `[Unreleased]` section as
changes are made, not batched right before a release — see the file's own
header for the Added/Changed/Fixed convention and why save-compatibility
gets called out explicitly for every entry (map mods can break existing
saves in ways typical software changes don't).

`modDesc.xml`'s `<version>` uses GIANTS' own 4-part `major.minor.patch.build`
scheme, not semver — `CHANGELOG.md` explains what each part means for this
project.

## Repository layout

- `map/` — the actual playable map: `map.i3d` (scene graph), `map.xml`
  (top-level config pointing at everything below), `config/*.xml`
  (placeables, farmlands, fields, fruitTypes, vehicles, storeItems,
  trafficSystem, etc.), `data/` (heightmap, density maps, terrain weight
  textures), `foliage/` (per-crop growth-stage textures).
- `assets/` — standalone `.i3d` props referenced by `map.i3d`
  (background terrain drape, farm buildings, dealership, co-op, lime
  station).
- `vehicles/` — custom vehicle XML variants (currently one: a no-till
  Great Plains seeder).
- `tools/` — one subfolder per data-generation pipeline (soil map, farmland
  pricing, PDA/overview image, background forest fill, traffic network,
  crop calendar). Each has its own README with the exact regenerate
  command and an explanation of what's cached vs. what's authoritative
  source. These scripts write into `map/` or `assets/`; they are not run
  automatically and nothing here ships in the release zip.

## i3d / GIANTS Editor conventions

- `.i3d` files can store geometry two ways: `<Shapes externalShapesFile="...">`
  pointing at a companion binary `.shapes` file (GE's normal save format), or
  inline `<IndexedTriangleSet>` XML directly in the `.i3d` (schema at
  `Farming Simulator 2025/shared/xml/schema/i3d-1.6.xsd`). GE silently
  converts inline geometry back to the compact external-binary form on its
  next save — useful when a shape needs to be written by a script instead
  of through GE's own import (GE's importer only accepts `.i3d`/`.fbx`, not
  `.obj`).
- **Static shape physics-mesh cooking has a hard ceiling around 65,536
  vertices** (16-bit index limit) — this applies regardless of
  `collision="false"`, since GE cooks static shapes' geometry either way.
  Exceeding it fails the whole shape with
  `Error: Physics Mesh Cooking failed, due to too many polygons in '<name>'.`
  If a mesh needs decimating to get under this, **recompute any UV that's a
  known function of vertex position analytically from the decimated
  vertex** rather than carrying it through a simplification library's
  collapse history — collapse-history UV carry-through is fine for smooth
  blend masks but visibly warps a photo-realistic texture.
- **`visibility="false"` on a node is a real, persisted, in-game-effective
  attribute** (set via the Attributes > Transform tab's "Visibility"
  control in GE). The scenegraph "eye" icon toggle is editor-preview-only
  and does **not** save to the i3d file — don't confuse the two.
- **A "preplaced placeable" is different from a plain scene-graph
  reference.** A real, functional placeable (income generation,
  specializations, shows up as owned/purchasable) needs an entry in
  `map/config/placeables.xml` (`<placeable isPreplaced="true"
  uniqueId="..." xmlFilename="..."/>`) *and* a matching `map.i3d` node:
  a `<TransformGroup name="preplaced_<name>" lockedgroup="true">` wrapping
  the reference, carrying `userAttributes` with `uniqueId`/`xmlFilename`
  that match the placeables.xml entry exactly. A `<ReferenceNode>` dropped
  into the scene without that wrapper and without a placeables.xml entry is
  purely decorative — no specializations, no income, nothing to configure.

## Traffic system (`map/config/trafficSystem.xml`, generated by `tools/traffic/`)

Four FS25 rules that all fail **completely silently** — a clean log does not
mean correct setup:

1. Splines must form closed loops. A lane that just stops logs
   `Error: Traffic system road spline '<name>' dead-end found at <x> <z>`
   and gets silently dropped — roads that run off the playable area need
   U-turn connectors joining the arriving lane back to the departing one.
2. Connectors may only meet lanes at endpoints. A turn connector attaching
   part-way along a lane counts as a dead end; the lane has to be actually
   cut into stub + body pieces at the branch point, not overlapped.
3. `parkedCars` must be the **last** child of its registered group. First or
   mid-list, nothing spawns and nothing logs it.
4. `probabilityParked` is eligibility (0 or 1 only), **not** a relative
   weight, even though the neighboring `probability` field is a weight.

Also: the registered group's name doesn't matter (base `mapUS` calls it
`trafficSplines`, not `trafficSystem`) — what matters is the
`onCreate=TrafficSystem.onCreate` UserAttribute, and exactly one node may
carry it. In-game position readouts run 0..4096 while the i3d world space
runs -2048..+2048 — subtract 2048 from both X and Z when converting
on-screen coordinates. XML comments in `trafficSystem.xml` must not contain
`--`, or the file becomes unparseable and the error points at the comment,
not at the vehicles.

## Git / release packaging

`.gitattributes` routes `*.dds *.png *.grle *.gdm *.shapes *.cache` through
Git LFS. `map/map.i3d` is **deliberately excluded** from LFS — kept as plain
diffable text specifically so node/UserAttribute regressions show up in
`git diff` (currently ~5.9MB).

**The three `map/map.i3d.terrain.*.cache` files are tracked and shipped.**
GIANTS ships them with every base map. They used to be gitignored and
stripped from the release zip on the theory that the engine regenerates
them on load — it does, but for this 4096 terrain that means rebuilding
~71MB of derived data (full-res normal map, LOD-type map, occluders) from
the heightmap on every load, which took 10–15 minutes on an Apple M3 Pro
and is the cause of "map takes forever to load" reports. A missing cache is
announced by `Warning: Missing terrain occluder cache ...` in the log; a
stall beginning within milliseconds of that line is this. GE rewrites all
three on save whenever the terrain changes, so the workflow is simply:
edit terrain in GE → save → commit the updated caches alongside `map.i3d`.
If `dem.png` is ever regenerated by a script instead, open and resave in GE
before committing or the caches will be stale.
Release zips are distributed as GitHub Release assets (see `BUILD.md`), not
committed to the repo — don't add anything under `releases/` to git.

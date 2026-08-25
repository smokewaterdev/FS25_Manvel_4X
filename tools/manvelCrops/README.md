# Manvel crop definitions

Regenerates every crop's foliage XML in `map/foliage/*/` from the base
game, rewritten with this map's own regional planting/harvest calendar,
then syncs `map/config/fruitTypes.xml` to point at those local copies.

**This script also resets the first 41 fields' crop/growth state in
`map/config/fields.xml` to a fixed baseline — see the warning below before
you re-run it.**

## What it does

1. For each of the 25 crops in the `CROPS` dict, copies the base game's
   foliage definition (`C:\Farming Simulator 2025\data\foliage\<crop>\`)
   into `map/foliage\<crop>\`, repoints its texture/model/sound paths back
   at `$data/foliage/...` (so it still uses the base game's assets rather
   than a local copy), and rewrites the growth-stage calendar using one of:
   - `annual` — a real planting window → harvest window → decay cycle,
     built from each crop's stage list (wheat, barley, canola, oat, maize,
     sunflower, soybean, potato, sugarbeet, sorghum, beetRoot, carrot,
     parsnip, greenBean, pea).
   - `planting_window` — planting allowed in a period range, no forced
     decay (spinach, grass, poplar).
   - `disable_planting` — player can't plant it at all (cotton, sugarcane,
     rice, riceLongGrain — regional crops that exist on the map but aren't
     player-plantable here).
   - `oilseed` — the oilseed radish cover-crop special case.
2. **ThundRFS RCS guard:** if `map/foliage\<crop>\<crop>.xml` already has a
   `thRowCropSystem` element (i.e. you've installed the Realistic Crop
   System prefab for that crop), the script uses *that* file as its
   source instead of the base game's, so RCS's row spacing, destruction
   states, and local asset paths survive a rerun instead of getting
   silently overwritten.
3. Rebuilds `map/config/fruitTypes.xml` from the base game's
   `maps_fruitTypes.xml`, remapping filenames from `$data/foliage/...` to
   `map/foliage/...`. This fails loudly (raises) if the base game ever
   ships a fruit type with no matching rule in `CROPS` — that's
   intentional, it means the crop list here is out of date.
4. Resets the crop/growth state of **the first 41 fields** in
   `map/config/fields.xml` to a fixed, hardcoded fruit/growth-state/
   ground-type list baked into the bottom of the script (asserts exactly
   41 fields exist). Field 38 = wheat, field 39 = soybeans, per the
   script's own print statement.

## ⚠️ Before you re-run this

Step 4 is a hard reset, not a merge — it overwrites whatever crops/growth
stages are currently sitting in the first 41 fields with the exact
snapshot hardcoded in the script, no matter what state you've since set
them to in-game or in GE. If you've hand-tuned field states since the
last run (for a screenshot, a specific save setup, testing, etc.), rerun
this and that's gone. It's really a "set the starting/demo state" step,
not a "sync my crop definitions" step — worth splitting those two
concerns into separate scripts if you find yourself wanting to update
crop calendars without touching field state.

It also hard-asserts field count == 41 — if you've added or removed
fields since this was written, the script will raise instead of silently
misapplying the list, which is the safe failure mode, but means you'll
need to update `field_states` in the script to match your current field
layout before it'll run again.

## Requirements

Needs a local Farming Simulator 2025 install at `C:\Farming Simulator
2025\data` (hardcoded as `GAME_DATA` at the top of the script — this
isn't a CLI argument, so if your game is installed somewhere else you'll
need to edit that constant).

## Usage

```
cd tools/manvelCrops
python3 build_manvel_crops.py
```

No arguments. Rerun after: adding a new crop folder under `map/foliage`,
changing a crop's regional planting/harvest window, or after a game
update changes the base game's foliage assets. Don't rerun casually just
to "sync" something — see the warning above.

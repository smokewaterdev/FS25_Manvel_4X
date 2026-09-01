# Cutting a release

How to package and publish a new version of Manvel 4X. This is a checklist for
future-you, not exhaustive documentation — see `.gitattributes` and
`tools/build_release.py` themselves for the reasoning behind specific choices.

## 1. Bump the version

Edit `modDesc.xml`:

```xml
<version>0.8.0.0</version>
```

Commit that on its own (`git commit -am "Bump version to 0.8.0.0"`) so the
version bump is a clean, findable commit.

## 2. Build the zip

```
python tools/build_release.py --version
```

Writes `releases/FS25_Manvel_4X.zip` and a version-tagged copy,
`releases/FS25_Manvel_4X_<version>.zip`, both read from `modDesc.xml`. The
`releases/` folder is gitignored — it's build output, never commit it.

What's excluded and why (edit `EXCLUDE_DIRS` / `EXCLUDE_FILES` /
`EXCLUDE_PATTERNS` at the top of the script if this needs to change):

- `.git/`, `tools/` — dev-only, not needed to play the map
- `map/CSVdata3/` — traffic pipeline source, already baked into `map.i3d`
- `manvel.osm`, both `AutoDrive*.xml` files — dev/local state, not part of the mod
- the six `densityMap_*.png` files in `map/data/` — GE's own paint-source
  companions to the `.gdm` binaries it ships next to; referenced only in
  `map.i3d`'s `<Files>` table, never in `map.xml`, so the game never loads
  them at runtime. Needed for continued editing in GE, not for players.
- GE terrain caches, `*_backup.*`, OS/Python junk

`README.md` **is** included on purpose — it's the player-facing doc now,
not just a repo doc.

Sanity-check what would ship without writing anything:

```
python tools/build_release.py --list-only
```

## 3. Tag it and create a GitHub Release

Don't check the zip into git and don't tell people to clone the repo — that
just re-creates the history bloat the LFS migration fixed. Releases store
the zip as a binary asset completely separate from the git repo and from
the LFS quota.

The tag and the release are the same action — creating a release on GitHub
lets you pick or create the tag right there, so there's no separate `git tag`
step needed first.

**Web UI:** repo page → Releases → "Draft a new release" → type a new tag
matching the version (e.g. `v0.8.0.0`) → drag
`releases/FS25_Manvel_4X_<version>.zip` into the assets box → write release
notes → Publish.

**`gh` CLI**, if set up on Windows:

```
gh release create v<version> releases/FS25_Manvel_4X_<version>.zip \
  --title "v<version>" --notes "..."
```

## 4. Push

Do this from Windows, not from any sandboxed/remote shell — pushing needs
your GitHub SSH key, and the pre-push hook needs `git lfs install` to have
been run at least once so it uploads LFS objects automatically.

```
git lfs install
git push origin main
git push origin v<version>          # only if you created the tag manually
                                     # instead of through a Release
```

## Known limits to watch

- **`map/map.i3d` is deliberately left out of Git LFS** (stays diffable
  text — that's how node/UserAttribute regressions get caught) but GitHub
  warns above 50MB and hard-rejects above 100MB. It was 54.29MB as of
  2026-09-01. If it keeps growing, either start diffing it less carefully
  and LFS-track `*.i3d`, or split the scene.
- **GitHub LFS free tier is 10GB storage / 10GB bandwidth per month**
  (Free/Pro plans) — this repo's LFS content is currently under 1GB, so
  there's plenty of headroom, but a lot of large new binaries between
  releases is worth keeping an eye on.
- **A force-push rewrites history for anyone else with a clone.** The
  2026-09-01 LFS migration already did the one big rewrite this repo should
  need; normal releases going forward are plain (non-force) pushes.

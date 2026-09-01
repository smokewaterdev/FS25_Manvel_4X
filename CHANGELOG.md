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

Changes since `0.8.0.0` that haven't shipped in a tagged release yet. Move
this section's contents under a new version heading (and bump
`modDesc.xml`) when you cut the next release — see `BUILD.md`.

### Added
-

### Changed
-

### Fixed
-

## [0.8.0.0]

Starting point — first version tracked in this changelog. Never published,
so no prior version history to reconcile against. When you cut the first
GitHub Release/tag, add the date to this heading (`[0.8.0.0] - YYYY-MM-DD`)
and move on to a fresh `[Unreleased]` section for whatever comes next.

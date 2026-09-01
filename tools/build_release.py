#!/usr/bin/env python3
"""
Build a clean, distributable FS25_Manvel_4X.zip for release.

Packages the mod folder into a zip with modDesc.xml at the zip root (the
format FS25 requires for a droppable mod zip), excluding dev-only content:
git metadata, the tools/ pipeline, editor terrain caches, local AutoDrive
test state, and other non-runtime files.

Usage (from anywhere, run with plain Python 3, no external deps):
    python tools/build_release.py
    python tools/build_release.py --version        # also write a
                                                     # version-tagged copy
    python tools/build_release.py --list-only       # dry run, no zip written

Output goes to releases/FS25_Manvel_4X.zip at the repo root. releases/ is
gitignored — it's a build artifact, not something to commit.
"""

import argparse
import fnmatch
import re
import sys
import zipfile
from pathlib import Path

MOD_NAME = "FS25_Manvel_4X"

# Directories excluded entirely (relative to repo root).
EXCLUDE_DIRS = {
    ".git",
    "tools",  # dev scripts, docs, source data (soil GeoJSON, etc.)
    "map/CSVdata3",  # traffic pipeline CSV/OBJ source, already merged into map.i3d
    "releases",  # build output itself
}

# Individual files excluded by exact repo-relative path.
EXCLUDE_FILES = {
    ".gitignore",
    ".gitattributes",
    "manvel.osm",  # dev source for the map layout, not needed at runtime
    "AutoDrive_init_config.xml",  # local AutoDrive test state, not part of the mod
    "AutoDriveUsersData.xml",
    # Density-map preview PNGs: GE keeps these as the paintable source next to
    # each runtime .gdm binary (referenced only in map.i3d's <Files> table,
    # never in map.xml). The game reads the .gdm directly at runtime, so these
    # are needed for continued editing in GE but not for a shipped release.
    "map/data/densityMap_fruits.png",
    "map/data/densityMap_ground.png",
    "map/data/densityMap_height.png",
    "map/data/densityMap_stones.png",
    "map/data/densityMap_weed.png",
    "map/data/densityMap_groundFoliage.png",
}

# Filename glob patterns excluded wherever they appear.
EXCLUDE_PATTERNS = [
    "*.i3d.terrain.lod.type.cache",
    "*.i3d.terrain.nmap.cache",
    "*.i3d.terrain.occluders.cache",
    "*_backup.*",
    "Thumbs.db",
    "desktop.ini",
    ".DS_Store",
    "*.pyc",
]
EXCLUDE_DIR_NAMES = {"__pycache__"}


def repo_root() -> Path:
    # This script lives at <repo>/tools/build_release.py
    return Path(__file__).resolve().parent.parent


def is_excluded(rel_path: Path) -> bool:
    parts = rel_path.parts
    rel_posix = rel_path.as_posix()

    # Directory-based exclusions (exact relative-dir match, or any excluded
    # dir name appearing anywhere in the path, e.g. __pycache__).
    for excl in EXCLUDE_DIRS:
        excl_parts = Path(excl).parts
        if parts[: len(excl_parts)] == excl_parts:
            return True
    if EXCLUDE_DIR_NAMES.intersection(parts[:-1]):
        return True

    # Exact file match.
    if rel_posix in EXCLUDE_FILES:
        return True

    # Glob patterns, matched against the filename.
    name = rel_path.name
    if any(fnmatch.fnmatch(name, pat) for pat in EXCLUDE_PATTERNS):
        return True

    return False


def read_version(root: Path) -> str:
    text = (root / "modDesc.xml").read_text(encoding="utf-8")
    m = re.search(r"<version>([^<]+)</version>", text)
    return m.group(1).strip() if m else "unknown"


def collect_files(root: Path) -> list[Path]:
    files = []
    for p in root.rglob("*"):
        if p.is_dir():
            continue
        rel = p.relative_to(root)
        if is_excluded(rel):
            continue
        files.append(rel)
    return sorted(files)


def build_zip(root: Path, files: list[Path], out_path: Path) -> None:
    out_path.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(out_path, "w", zipfile.ZIP_DEFLATED, compresslevel=6) as zf:
        for rel in files:
            zf.write(root / rel, arcname=rel.as_posix())


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--version", action="store_true",
        help="also write a version-tagged copy, e.g. FS25_Manvel_4X_0.8.0.0.zip",
    )
    parser.add_argument(
        "--list-only", action="store_true",
        help="print what would be included/excluded, write no zip",
    )
    args = parser.parse_args()

    root = repo_root()
    if not (root / "modDesc.xml").exists():
        sys.exit(f"modDesc.xml not found at {root} — is this script still under tools/?")

    files = collect_files(root)
    total_bytes = sum((root / f).stat().st_size for f in files)

    print(f"Repo root: {root}")
    print(f"Files to include: {len(files)}  ({total_bytes / 1_048_576:.1f} MB uncompressed)")

    if args.list_only:
        for f in files:
            print(f"  {f.as_posix()}")
        return

    out_dir = root / "releases"
    out_path = out_dir / f"{MOD_NAME}.zip"
    build_zip(root, files, out_path)
    print(f"Wrote {out_path}  ({out_path.stat().st_size / 1_048_576:.1f} MB)")

    if args.version:
        ver = read_version(root)
        ver_path = out_dir / f"{MOD_NAME}_{ver}.zip"
        build_zip(root, files, ver_path)
        print(f"Wrote {ver_path}  ({ver_path.stat().st_size / 1_048_576:.1f} MB)")


if __name__ == "__main__":
    main()

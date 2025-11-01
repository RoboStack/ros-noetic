#!/usr/bin/env python3
"""
check_patches_clean_apply.py
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Scan *all* recipes inside the **recipes/** folder, keep only the parts
needed to verify that every declared *patch* still applies, and then
run **rattler-build** so the patch phase is executed – nothing else.

Usage
-----

    # From repository root
    python .scripts/check_patches_clean_apply.py          # prepare + run
    python .scripts/check_patches_clean_apply.py --dry    # prepare only
    python .scripts/check_patches_clean_apply.py --clean  # delete output

The script creates (or refreshes) a sibling folder named
*recipes_only_patch*.  Every recipe that declares *patches:* gets a
**minimal** copy there; files referenced in *patches* are copied too.

Implementation details
----------------------

* Accepts both mapping or list forms of *source*.
* Strips out *requirements*, *test*, *outputs*… – only *package*,
  *source* and a stub *build* section remain.
* Automatically invokes ``rattler-build build`` if *--dry* is **not**
  given.
"""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any, Dict, List, Union
import yaml


ROOT_DIR = Path.cwd()
RECIPES_DIR = ROOT_DIR / "recipes"
PATCH_RECIPES_DIR = ROOT_DIR / "recipes_only_patch"


def parse_args() -> argparse.Namespace:
    ap = argparse.ArgumentParser(description="Check that patches apply cleanly.")
    ap.add_argument(
        "--dry",
        action="store_true",
        help="Only generate recipes_only_patch/, don’t run rattler-build",
    )
    ap.add_argument(
        "--clean",
        action="store_true",
        help="Remove recipes_only_patch/ and exit",
    )
    return ap.parse_args()


def find_recipe_files() -> List[Path]:
    return sorted(RECIPES_DIR.rglob("recipe.yaml"))


def filter_sources(src: Union[Dict[str, Any], List[Dict[str, Any]]]) -> List[Dict[str, Any]]:
    if isinstance(src, dict):
        return [src] if "patches" in src else []
    elif isinstance(src, list):
        return [entry for entry in src if isinstance(entry, dict) and "patches" in entry]
    return []


def copy_patch_files(
    filtered_sources: List[Dict[str, Any]], orig_recipe_dir: Path, dest_recipe_dir: Path
) -> None:
    for entry in filtered_sources:
        patches = entry["patches"]
        if isinstance(patches, str):
            patches = [patches]
        for p in patches:
            if p.startswith(("http://", "https://")):
                # Remote patches – nothing to copy
                continue
            src_patch = (orig_recipe_dir / p).resolve()
            dest_patch = dest_recipe_dir / p
            dest_patch.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src_patch, dest_patch)


def write_minimal_recipe(
    dest_recipe_file: Path, pkg: Dict[str, Any], filtered_sources: List[Dict[str, Any]]
) -> None:
    minimal = {
        "package": pkg,
        "source": filtered_sources,
        "build": {"number": 0, "script": "echo patch-check"},
    }
    dest_recipe_file.parent.mkdir(parents=True, exist_ok=True)
    with dest_recipe_file.open("w", encoding="utf-8") as fh:
        yaml.dump(minimal, fh, sort_keys=False)


def prepare_patch_recipes() -> List[Path]:
    recreated: List[Path] = []
    for recipe_file in find_recipe_files():
        with recipe_file.open("r", encoding="utf-8") as fh:
            recipe = yaml.safe_load(fh) or {}

        src_section = recipe.get("source")
        if src_section is None:
            continue
        filtered = filter_sources(src_section)
        if not filtered:
            # No patches -> skip
            continue

        pkg = recipe.get("package", {"name": recipe_file.parent.name, "version": "0"})
        rel_dir = recipe_file.parent.relative_to(RECIPES_DIR)
        dest_recipe_dir = PATCH_RECIPES_DIR / rel_dir
        dest_recipe_file = dest_recipe_dir / "recipe.yaml"

        copy_patch_files(filtered, recipe_file.parent, dest_recipe_dir)
        # append "-check-patches" to the package name in the dummy recipe
        patched_pkg = dict(pkg)
        patched_pkg["name"] = f"{patched_pkg['name']}-check-patches"
        write_minimal_recipe(dest_recipe_file, patched_pkg, filtered)
        recreated.append(dest_recipe_file)

    return recreated


def run_rattler_build() -> None:
    cmd = [
        "rattler-build",
        "build",
        "--recipe-dir",
        str(PATCH_RECIPES_DIR)
    ]
    print("\n Running:", " ".join(cmd), "\n", flush=True)
    subprocess.run(cmd, check=True)


def main() -> None:
    args = parse_args()

    if not RECIPES_DIR.is_dir():
        print("recipes/ folder not found – abort.")
        sys.exit(1)

    if args.clean:
        shutil.rmtree(PATCH_RECIPES_DIR, ignore_errors=True)
        print(" Removed recipes_only_patch/")
        return

    if PATCH_RECIPES_DIR.exists():
        print("Refreshing recipes_only_patch/ …")
        shutil.rmtree(PATCH_RECIPES_DIR)

    recreated = prepare_patch_recipes()
    if not recreated:
        print("No recipes with patches found – nothing to test.")
        return

    print(f"Prepared {len(recreated)} minimal recipe(s) in {PATCH_RECIPES_DIR}/")

    if not args.dry:
        run_rattler_build()
    else:
        print("--dry given – rattler-build not executed.")


if __name__ == "__main__":
    main()


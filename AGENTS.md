# AGENTS.md

Working notes for future coding agents in a RoboStack repo. Replace $DISTRO with e.g. noetic/humble/kilted and so forth; you can check the working directory.

## Session defaults for this repo

- Prefer fixing easy, low-risk build failures first (one-line CMake / include / standard-level fixes).
- Do not stop to ask the maintainer to run commands; run build/debug loops directly.
- Use checked-out sources in `.pixi` and `output/src_cache` when patching.
- Use `./build_gap_report.py` to track build/recipe gaps across platforms:
  - `Built package artifacts without matching recipe directory`: packages built in `output/<platform>` that are not represented as recipe folders.
  - `Recipe directories without built artifact on this platform`: generated recipes that still need successful builds for that platform.
- If a package is truly Linux-only, move it to Linux-only handling in `vinca.yaml` (or non-linux skip), instead of keeping ad-hoc macOS comments. Follow similar strategies for other platforms such as Windows.
- For patch naming, keep one patch per package and use package-based naming (`patch/ros-$DISTRO-<pkg>.patch`) with no extra suffix variants.

## Standard build loop

```bash
# single package (preferred for debugging)
pixi run build-one --package ros-$DISTRO-<pkg>

# broad pass when needed
pixi run build_continue_on_failure
```

## Common fix patterns seen in this repo

- Boost 1.88 breakages often need C++14 (`-std=c++14`) instead of `-std=c++11`.
- Avoid linking to `Python::Python` on Apple for module-style targets; use:

```cmake
if( APPLE )
  set_target_properties( ${_name} PROPERTIES LINK_FLAGS "-undefined dynamic_lookup" )
else()
  target_link_libraries( ${_name} ${PYTHON_LIBRARIES} )
endif()
```

- For gtest-related failures, prefer dependency or test-disable fixes over custom shims:
  - add dependency via `patch/dependencies.yaml`, or
  - disable tests when safe.
- For rtabmap RViz plugin issues, force/confirm Qt5 discovery in CMake where needed.

## Debug a failed build

### 1. Find the work directory

```bash
tail -1 output/rattler-build-log.txt
```

### 2. Inspect full log

Read `conda_build.log` in the work dir. Focus on:
- compile errors
- link errors
- configure failures
- patch failures
- missing files

### 3. Inspect build env

Read `build_env.sh` in the work dir:
- `PREFIX`
- `BUILD_PREFIX`
- `SRC_DIR`
- `RECIPE_DIR`

### 4. Check fetched source metadata

```bash
cat .source_info.json | jq .
```

### 5. Investigate by failure class

- Missing headers: check `requirements.host`; verify under `$PREFIX/include`.
- Undefined symbols: check host deps, `$PREFIX/lib`, linker flags.
- Configure failures: inspect flags in `conda_build.sh`; rerun manually with verbosity.
- Patch failures: refresh patch against current source revision.
- Relocatability issues: inspect hardcoded prefixes/rpaths.

### 6. Reproduce interactively

```bash
cd <work-directory>
source build_env.sh
bash -x conda_build.sh 2>&1 | less
```

### 7. Rebuild package

```bash
pixi run build-one --package ros-$DISTRO-<pkg>
```

## Create a patch from build-directory edits

```bash
WORK_DIR=$(tail -1 output/rattler-build-log.txt)
cd "$WORK_DIR"

# preview first
rattler-build create-patch --directory . --name <patch-name> --dry-run

# with excludes if needed
rattler-build create-patch \
  --directory . \
  --name <patch-name> \
  --exclude "*.o,*.so,*.dylib,*.a,*.pyc,__pycache__,build/" \
  --dry-run

# generate
rattler-build create-patch \
  --directory . \
  --name <patch-name> \
  --exclude "*.o,*.so,*.dylib,*.a,*.pyc,__pycache__,build/"
```

Then move/merge patch into repo package patch file and ensure recipe uses it.

## Validate that patches still apply

Use the patch checker before/after large patch edits:

```bash
pixi run check-patches
```

For faster iteration on one package patch, run the script directly with a recipe filter:

```bash
# prepare + check only one recipe
python check_patches_clean_apply.py --recipe ros-$DISTRO-<pkg>

# prepare only (no build), useful while editing
python check_patches_clean_apply.py --dry --recipe ros-$DISTRO-<pkg>

# multiple focused recipes
python check_patches_clean_apply.py --recipe ros-$DISTRO-<pkg1> --recipe ros-$DISTRO-<pkg2>
```

What it does:
- scans all `recipes/**/recipe.yaml`
- keeps only recipes that declare `source.patches`
- creates `recipes_only_patch/` with minimal patch-check recipes
- runs patch application checks recipe-by-recipe and prints a pass/fail summary

## Patch placement and recipe wiring

- Canonical patch location: `patch/ros-$DISTRO-<pkg>.patch`
- Keep recipe copy in `recipes/ros-$DISTRO-<pkg>/patch/` if this repo flow expects it.
- Ensure `recipes/ros-$DISTRO-<pkg>/recipe.yaml` has:

```yaml
source:
  patches:
    - patch/ros-$DISTRO-<pkg>.patch
```

## Parallelization and dependency-aware scheduling

It is worth splitting work across multiple agents, but only for independent packages.

Rules:
- Do not build dependent packages in parallel.
- Infer dependency relationships from `recipes/ros-$DISTRO-<pkg>/recipe.yaml` (`requirements.host` and `requirements.run`).
- If package A depends on package B (for example `rosmon` -> `rosmon-core`), build/fix B first.
- Run parallel lanes only for packages that do not depend on each other.
- If unsure, serialize the builds.

## Inspect a built conda package

```bash
find output/ -name "*<package-name>*" -type f \( -name "*.conda" -o -name "*.tar.bz2" \)
```

For `.conda` artifacts:

```bash
TMPDIR=$(mktemp -d)
cd "$TMPDIR"
unzip -q <package.conda>
zstd -d < pkg-*.tar.zst | tar -xvf -
zstd -d < info-*.tar.zst | tar -xvf -
```

Check:
- `info/index.json` (deps/build string)
- `info/paths.json` (installed files)
- binaries/libs/rpaths (`otool -L` on macOS)
- hardcoded prefixes in text metadata

## `vinca.yaml` maintenance guidelines

- Add package seeds under `packages_select_by_deps` using ROS package names (dash/underscore accepted).
- Use platform conditions for Linux-only packages; avoid temporary macOS comment blocks.
- Keep `packages_skip_by_deps` and `packages_remove_from_deps` coherent with platform constraints.
- When `build_gap_report.py` shows built artifacts without recipe directories, add those package seeds to `vinca.yaml`.
- After `vinca.yaml` edits, regenerate recipes before expecting `build_gap_report.py` results to change.

## Local contribution workflow (RoboStack)

```bash
pixi run build
```

## Full rebuilds
For full rebuilds also remember:
- refresh snapshot: `pixi run create_snapshot`
- update `conda_build_config.yaml` for active migrations. You can use https://github.com/conda-forge/conda-forge-pinning-feedstock/blob/main/recipe/conda_build_config.yaml as a base, and then also apply migrations that are mostly done; you can check the status at https://conda-forge.org/status/.
- bump `build_number`
- bump mutex minor and update hardcoded mutex refs where needed
- clear stale `pkg_additional_info.yaml` build-number overrides unless intentional
- remember that in CI there is a build cache, if you fix a problem in an already built package you need to delete the cache for this package in the .github/workflows/testpr.yml under "Delete specific outdated cache entries"

## Practical triage order

1. Build a failing package directly.
2. Apply smallest viable source or recipe fix.
3. Update package patch file (package-named).
4. Rebuild same package.
5. Move on immediately if it becomes complex; prioritize easy wins.
6. Revisit hard failures after reducing the failure queue.

#!/usr/bin/env bash

# Default values
target=""

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --target) target="$2"; shift ;;  # Capture value for --target
        *) echo "Unknown parameter passed: $1"; exit 1 ;;  # Handle invalid options
    esac
    shift
done

set -xeuo pipefail
export PYTHONUNBUFFERED=1

export FEEDSTOCK_ROOT=`pwd`
export "CONDA_BLD_PATH=$HOME/conda-bld/"

curl -fsSL https://pixi.sh/install.sh | bash
export PATH="$HOME/.pixi/bin:$PATH"

if [[ "$target" == *"osx"* ]]; then
    echo "osx"
    export PATH=$(echo $PATH | tr ":" "\n" | grep -v 'homebrew' | xargs | tr ' ' ':')
fi

extra_channel=""
cross_compile=""

for recipe in ${CURRENT_RECIPES[@]}; do
	pixi run -v rattler-build build \
		--recipe ${FEEDSTOCK_ROOT}/recipes/${recipe} \
		-m ${FEEDSTOCK_ROOT}/conda_build_config.yaml \
		-c robostack-staging -c conda-forge \
		${extra_channel} \
		--output-dir $CONDA_BLD_PATH \
		${cross_compile}
		# -m ${FEEDSTOCK_ROOT}/.ci_support/conda_forge_pinnings.yaml \

done

pixi run upload ${CONDA_BLD_PATH}/${target}*/*.conda --force

#!/bin/bash

set -x

export FEEDSTOCK_ROOT=`pwd`

"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
source ~/.bash_profile

echo -e "\n\nInstalling conda-forge-ci-setup=3 and conda-build."
micromamba create -n devenv --quiet --yes conda-forge-ci-setup=3 conda-build=3.27 pip boa quetz-client -c conda-forge
micromamba activate devenv

set -e

export "CONDA_BLD_PATH=$CONDA_PREFIX/conda-bld/"

mkdir -p $CONDA_BLD_PATH

micromamba config append channels conda-forge --env
micromamba config append channels robostack-staging --env
micromamba config append channels $CONDA_BLD_PATH --env

for recipe in ${CURRENT_RECIPES[@]}; do
	cd ${FEEDSTOCK_ROOT}/recipes/${recipe}
	boa build . -m ${FEEDSTOCK_ROOT}/.ci_support/conda_forge_pinnings.yaml -m ${FEEDSTOCK_ROOT}/conda_build_config.yaml
done

anaconda -t ${ANACONDA_API_TOKEN} upload ${CONDA_BLD_PATH}/osx-arm64/*.tar.bz2 --force

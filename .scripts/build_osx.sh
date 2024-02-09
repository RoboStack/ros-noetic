#!/bin/bash

set -x

export FEEDSTOCK_ROOT=`pwd`

"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
source ~/.zshrc

echo -e "\n\nInstalling conda-forge-ci-setup=3 and conda-build."
micromamba create -n devenv --quiet --yes conda-forge-ci-setup=3 conda-build=3.27 pip boa quetz-client -c conda-forge
micromamba activate devenv

set -e

# echo -e "\n\nSetting up the condarc and mangling the compiler."
# # setup_conda_rc ./ ./recipe ./.ci_support/${CONFIG}.yaml
# # mangle_compiler ./ ./recipe .ci_support/${CONFIG}.yaml

# echo -e "\n\nMangling homebrew in the CI to avoid conflicts."
# # /usr/bin/sudo mangle_homebrew
# # /usr/bin/sudo -k

# echo -e "\n\nRunning the build setup script."
# # source run_conda_forge_build_setup

export "CONDA_BLD_PATH=$CONDA_PREFIX/conda-bld/"

mkdir -p $CONDA_BLD_PATH
micromamba index $CONDA_BLD_PATH
micromamba config append channels conda-forge --env
micromamba config append channels robostack-staging --env
micromamba config append channels $CONDA_BLD_PATH --env

for recipe in ${CURRENT_RECIPES[@]}; do
	cd ${FEEDSTOCK_ROOT}/recipes/${recipe}
	if [[ ${recipe} == *"rviz" || ${recipe} == *"moveit-setup-assistant" || ${recipe} == *"turtlesim" ]]; then
		boa build . -m ${FEEDSTOCK_ROOT}/.ci_support/conda_forge_pinnings.yaml -m ${FEEDSTOCK_ROOT}/conda_build_config.yaml -m ${FEEDSTOCK_ROOT}/conda_build_config_old_osx.yaml
	else
		boa build . -m ${FEEDSTOCK_ROOT}/.ci_support/conda_forge_pinnings.yaml -m ${FEEDSTOCK_ROOT}/conda_build_config.yaml
	fi
done

anaconda -t ${ANACONDA_API_TOKEN} upload ${CONDA_BLD_PATH}/osx-64/*.tar.bz2 --force

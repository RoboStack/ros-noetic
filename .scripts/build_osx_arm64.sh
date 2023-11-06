#!/bin/bash

set -x

export FEEDSTOCK_ROOT=`pwd`

echo -e "\n\nInstalling a fresh version of Miniforge."
MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download"
MINIFORGE_FILE="Mambaforge-MacOSX-x86_64.sh"
curl -L -O --silent "${MINIFORGE_URL}/${MINIFORGE_FILE}"
/bin/bash $MINIFORGE_FILE -b

echo -e "\n\nConfiguring conda."

source ${HOME}/mambaforge/etc/profile.d/conda.sh
conda activate base

conda config --set remote_max_retries 5

echo -e "\n\nInstalling conda-forge-ci-setup=3 and conda-build."
mamba install -n base --quiet --yes conda-forge-ci-setup=3 conda-build pip boa quetz-client -c conda-forge

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
conda index $CONDA_BLD_PATH
conda config --set anaconda_upload yes
conda config --set show_channel_urls true
conda config --set auto_update_conda false
conda config --set add_pip_as_python_dependency false

conda config --add channels conda-forge
conda config --add channels robostack-staging
conda config --add channels $CONDA_BLD_PATH
# conda config --set channel_priority strict

# echo -e "\n\nMaking the build clobber file and running the build."
# make_build_number ./ ./recipe ./.ci_support/${CONFIG}.yaml

conda info
conda config --show-sources
conda list --show-channel-urls

for recipe in ${CURRENT_RECIPES[@]}; do
	cd ${FEEDSTOCK_ROOT}/recipes/${recipe}
	boa build . -m ${FEEDSTOCK_ROOT}/.ci_support/conda_forge_pinnings.yaml -m ${FEEDSTOCK_ROOT}/conda_build_config.yaml --target-platform=osx-arm64
done

anaconda -t ${ANACONDA_API_TOKEN} upload ${CONDA_BLD_PATH}/osx-arm64/*.tar.bz2 --force
# quetz-client "${QUETZ_URL}" ${CONDA_BLD_PATH} --force

# conda build ./recipe -m ./.ci_support/${CONFIG}.yaml --clobber-file ./.ci_support/clobber_${CONFIG}.yaml

# if [[ "${UPLOAD_PACKAGES}" != "False" ]]; then
#   echo -e "\n\nUploading the packages."
#   upload_package --validate --feedstock-name="libsolv-feedstock" ./ ./recipe ./.ci_support/${CONFIG}.yaml
# fi

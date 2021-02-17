# RoboStack (for ROS Noetic)
[![Conda](https://img.shields.io/conda/dn/robostack/ros-noetic-desktop?style=flat-square)](https://anaconda.org/robostack/)
[![Gitter](https://img.shields.io/gitter/room/RoboStack/Lobby?style=flat-square)](https://gitter.im/RoboStack/Lobby)
[![GitHub Repo stars](https://img.shields.io/github/stars/robostack/ros-noetic?style=flat-square)](https://github.com/RoboStack/ros-noetic/)
[![HitCount](http://hits.dwyl.com/RoboStack/ros-noetic.svg)](http://hits.dwyl.com/RoboStack/ros-noetic)
[![QUT Centre for Robotics](https://img.shields.io/badge/collection-QUT%20Robotics-%23043d71?style=flat-square)](https://qcr.ai)

[![Platforms](https://img.shields.io/badge/platforms-linux%20%7C%20win%20%7C%20macos%20%7C%20linux%E2%80%93aarch64-green.svg?style=flat-square)](https://github.com/RoboStack/ros-noetic)
[![Azure DevOps builds (branch)](https://img.shields.io/azure-devops/build/roboforge/f91d909b-3931-44f7-9823-19fcd42e7d04/8/buildbranch_linux?label=build%20linux&style=flat-square)](https://dev.azure.com/roboforge/ros_pipelines/_build?definitionId=8&_a=summary)
[![Azure DevOps builds (branch)](https://img.shields.io/azure-devops/build/roboforge/f91d909b-3931-44f7-9823-19fcd42e7d04/10/buildbranch_win?label=build%20win&style=flat-square)](https://dev.azure.com/roboforge/ros_pipelines/_build?definitionId=10&_a=summary)
[![Azure DevOps builds (branch)](https://img.shields.io/azure-devops/build/roboforge/f91d909b-3931-44f7-9823-19fcd42e7d04/9/buildbranch_osx?label=build%20macos&style=flat-square)](https://dev.azure.com/roboforge/ros_pipelines/_build?definitionId=9&_a=summary)
[![Azure DevOps builds (branch)](https://img.shields.io/azure-devops/build/roboforge/f91d909b-3931-44f7-9823-19fcd42e7d04/11/buildbranch_linux_aarch64?label=build%20aarch64&style=flat-square)](https://dev.azure.com/roboforge/ros_pipelines/_build?definitionId=11&_a=summary)

[![GitHub issues](https://img.shields.io/github/issues-raw/robostack/ros-noetic?style=flat-square)](https://github.com/RoboStack/ros-noetic/issues)
[![GitHub closed issues](https://img.shields.io/github/issues-closed-raw/robostack/ros-noetic?style=flat-square)](https://github.com/RoboStack/ros-noetic/issues?q=is%3Aissue+is%3Aclosed)
[![GitHub pull requests](https://img.shields.io/github/issues-pr-raw/robostack/ros-noetic?style=flat-square)](https://github.com/RoboStack/ros-noetic/pulls)
[![GitHub closed pull requests](https://img.shields.io/github/issues-pr-closed-raw/robostack/ros-noetic?style=flat-square)](https://github.com/RoboStack/ros-noetic/pulls?q=is%3Apr+is%3Aclosed)

[__Table with all available packages & architectures__](https://robostack.github.io/noetic.html)

## Why ROS and Conda?
Welcome to RoboStack, which tightly couples ROS with Conda, a cross-platform, language-agnostic package manager. We provide ROS binaries for Linux, macOS, Windows and ARM (Linux). Installing other recent packages via conda-forge side-by-side works easily, e.g. you can install TensorFlow/PyTorch in the same environment as ROS Noetic without any issues. As no system libraries are used, you can also easily install ROS Noetic on any recent Linux Distribution - including older versions of Ubuntu. As the packages are pre-built, it saves you from compiling from source, which is especially helpful on macOS and Windows. No root access is required, all packages live in your home directory.

## Installation

To get started with conda (or mamba) as package managers, you need to have a base conda installation. Please do _not_ use the Anaconda installer, but rather start with [`miniforge` / `mambaforge`](https://github.com/conda-forge/miniforge) or [`miniconda`](https://docs.conda.io/en/latest/miniconda.html), which are much more "minimal" installers. These installers will create a "base" environment that contains the package managers conda (and mamba if you go with `mambaforge`). After this installation is done, you can move on to the next steps.

> Note: Make sure to _not_ install the ROS packages (in particular the `ros-noetic-catkin` package) in your base environment as this leads to issues down the track. Also do not source the system ROS environment, as the `PYTHONPATH` set in the setup script conflicts with the conda environment.

```bash
conda create -n robostackenv python=3.8
conda activate robostackenv
# this adds the conda-forge channel to your persistent configuration in ~/.condarc
conda config --add channels conda-forge
# and the robostack channel
conda config --add channels robostack
# it's very much advised to use strict channel priority
conda config --set channel_priority strict
# either
conda install ros-noetic-desktop
# or if you have mamba and want to use it
mamba install ros-noetic-desktop
# reload environment to activate required scripts before running anything
conda deactivate
conda activate robostackenv
```

[Here](https://anaconda.org/search?q=ros-noetic) is a list of available packages.

**Note: at the moment on Windows only the Command Prompt terminal is supported, while Powershell is not supported.**

## Reporting issues
Feel free to open issues in this repository's [issue tracker](https://github.com/RoboStack/ros-noetic/issues) (please check whether your problem is already listed there before opening a new issue) or come around on [Gitter](https://gitter.im/RoboStack/Lobby) to have a chat / ask questions. Please note that this repository is _not an official distribution of ROS_ and relies on volunteers. It is further highly experimental - unfortunately things might not work immediately out-of-the-box, although we try our best.

## Contributing
This project is in early stages and we are looking for contributors to help it grow. Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for ways to contribute.

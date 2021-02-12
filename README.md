# RoboStack (for ROS Noetic)
[![Conda](https://img.shields.io/conda/dn/robostack/ros-noetic-desktop?style=flat-square)](https://anaconda.org/robostack/)
[![Gitter](https://img.shields.io/gitter/room/RoboStack/Lobby?style=flat-square)](https://gitter.im/RoboStack/Lobby)
[![GitHub Repo stars](https://img.shields.io/github/stars/robostack/ros-noetic?style=flat-square)](https://github.com/RoboStack/ros-noetic/)
[![HitCount](http://hits.dwyl.io/RoboStack/ros-noetic.svg)](https://github.com/RoboStack/ros-noetic/)
[![QUT Centre for Robotics](https://img.shields.io/badge/collection-QUT%20Robotics-%23043d71?style=flat-square)](https://qcr.ai)

[![Platforms](https://img.shields.io/badge/platforms-linux%20%7C%20win%20%7C%20osx%20%7C%20linux%E2%80%93aarch64-green.svg?style=flat-square)](https://github.com/RoboStack/ros-noetic)
[![Azure DevOps builds (branch)](https://img.shields.io/azure-devops/build/roboforge/f91d909b-3931-44f7-9823-19fcd42e7d04/8/buildbranch_linux?label=build%20linux&style=flat-square)](https://dev.azure.com/roboforge/ros_pipelines/_build?definitionId=8&_a=summary)
[![Azure DevOps builds (branch)](https://img.shields.io/azure-devops/build/roboforge/f91d909b-3931-44f7-9823-19fcd42e7d04/10/buildbranch_win?label=build%20win&style=flat-square)](https://dev.azure.com/roboforge/ros_pipelines/_build?definitionId=10&_a=summary)
[![Azure DevOps builds (branch)](https://img.shields.io/azure-devops/build/roboforge/f91d909b-3931-44f7-9823-19fcd42e7d04/9/buildbranch_osx?label=build%20osx&style=flat-square)](https://dev.azure.com/roboforge/ros_pipelines/_build?definitionId=9&_a=summary)
[![Azure DevOps builds (branch)](https://img.shields.io/azure-devops/build/roboforge/f91d909b-3931-44f7-9823-19fcd42e7d04/11/buildbranch_linux_aarch64?label=build%20aarch64&style=flat-square)](https://dev.azure.com/roboforge/ros_pipelines/_build?definitionId=11&_a=summary)

[![GitHub issues](https://img.shields.io/github/issues-raw/robostack/ros-noetic?style=flat-square)](https://github.com/RoboStack/ros-noetic/issues)
[![GitHub closed issues](https://img.shields.io/github/issues-closed-raw/robostack/ros-noetic?style=flat-square)](https://github.com/RoboStack/ros-noetic/issues?q=is%3Aissue+is%3Aclosed)
[![GitHub pull requests](https://img.shields.io/github/issues-pr-raw/robostack/ros-noetic?style=flat-square)](https://github.com/RoboStack/ros-noetic/pulls)
[![GitHub closed pull requests](https://img.shields.io/github/issues-pr-closed-raw/robostack/ros-noetic?style=flat-square)](https://github.com/RoboStack/ros-noetic/pulls?q=is%3Apr+is%3Aclosed)

## Why ROS and Conda?
Welcome to RoboStack, which tightly couples ROS with Conda, a cross-platform, language-agnostic package manager. We provide ROS binaries for Linux, OSX, Windows and ARM (Linux). Installing other recent packages via conda-forge side-by-side works easily, e.g. you can install TensorFlow/PyTorch in the same environment as ROS Noetic without any issues. As no system libraries are used, you can also easily install ROS Noetic on any recent Linux Distribution - including older versions of Ubuntu. As the packages are pre-built, it saves you from compiling from source, which is especially helpful on OSX and Windows. No root access is required, all packages live in your home directory.

## Installation

Note: Make sure to _not_ install the ROS packages (in particular the `ros-noetic-catkin` package) in your base environment as this leads to issues down the track. Also do not source the system ROS environment, as the `PYTHONPATH` set in the setup script conflicts with the conda environment.

```
conda create -n robostackenv python=3.8
conda activate robostackenv
conda config --append channels defaults
conda config --add channels conda-forge
conda config --add channels robostack
conda config --set channel_priority strict
conda install pip mamba conda catkin_pkg ruamel_yaml rosdistro empy networkx requests compilers cmake pkg-config
mamba install ros-noetic-desktop
# reload environment to activate required scripts before running anything
conda deactivate
conda activate robostackenv
```

[Here](https://anaconda.org/search?q=ros-noetic) is a list of available packages.

## Reporting issues
Feel free to open issues in this repository's [issue tracker](https://github.com/RoboStack/ros-noetic/issues) (please check whether your problem is already listed there before opening a new issue) or come around on [Gitter](https://gitter.im/RoboStack/Lobby) to have a chat / ask questions. Please note that this repository is _not an official distribution of ROS_ and relies on volunteers. It is further highly experimental - unfortunately things might not work immediately out-of-the-box, although we try our best.

## Contributing
This project is in early stages and we are looking for contributors to help it grow. Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for ways to contribute.

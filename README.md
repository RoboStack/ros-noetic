# RoboStack (for ROS Noetic)
[![Conda](https://img.shields.io/conda/dn/robostack/ros-noetic-desktop?style=flat-square)](https://anaconda.org/robostack/)
[![Gitter](https://img.shields.io/gitter/room/RoboStack/Lobby?style=flat-square)](https://gitter.im/RoboStack/Lobby)
[![GitHub Repo stars](https://img.shields.io/github/stars/robostack/ros-noetic?style=flat-square)](https://github.com/RoboStack/ros-noetic/)
[![QUT Centre for Robotics](https://img.shields.io/badge/collection-QUT%20Robotics-%23043d71?style=flat-square)](https://qcr.ai)

[![Platforms](https://img.shields.io/badge/platforms-linux%20%7C%20win%20%7C%20macos%20%7C%20linux%E2%80%93aarch64-green.svg?style=flat-square)](https://github.com/RoboStack/ros-noetic)
[![Azure DevOps builds (branch)](https://img.shields.io/azure-devops/build/robostack/f91d909b-3931-44f7-9823-19fcd42e7d04/8/buildbranch_linux?label=build%20linux&style=flat-square)](https://dev.azure.com/robostack/ros_pipelines/_build?definitionId=8&_a=summary)
[![Azure DevOps builds (branch)](https://img.shields.io/azure-devops/build/robostack/f91d909b-3931-44f7-9823-19fcd42e7d04/10/buildbranch_win?label=build%20win&style=flat-square)](https://dev.azure.com/robostack/ros_pipelines/_build?definitionId=10&_a=summary)
[![Azure DevOps builds (branch)](https://img.shields.io/azure-devops/build/robostack/f91d909b-3931-44f7-9823-19fcd42e7d04/9/buildbranch_osx?label=build%20macos&style=flat-square)](https://dev.azure.com/robostack/ros_pipelines/_build?definitionId=9&_a=summary)
[![Azure DevOps builds (branch)](https://img.shields.io/azure-devops/build/robostack/f91d909b-3931-44f7-9823-19fcd42e7d04/11/buildbranch_linux_aarch64?label=build%20aarch64&style=flat-square)](https://dev.azure.com/robostack/ros_pipelines/_build?definitionId=11&_a=summary)

[![GitHub issues](https://img.shields.io/github/issues-raw/robostack/ros-noetic?style=flat-square)](https://github.com/RoboStack/ros-noetic/issues)
[![GitHub closed issues](https://img.shields.io/github/issues-closed-raw/robostack/ros-noetic?style=flat-square)](https://github.com/RoboStack/ros-noetic/issues?q=is%3Aissue+is%3Aclosed)
[![GitHub pull requests](https://img.shields.io/github/issues-pr-raw/robostack/ros-noetic?style=flat-square)](https://github.com/RoboStack/ros-noetic/pulls)
[![GitHub closed pull requests](https://img.shields.io/github/issues-pr-closed-raw/robostack/ros-noetic?style=flat-square)](https://github.com/RoboStack/ros-noetic/pulls?q=is%3Apr+is%3Aclosed)

[__Table with all available packages & architectures__](https://robostack.github.io/noetic.html)

## Why ROS and Conda?
Welcome to RoboStack, which tightly couples ROS with Conda, a cross-platform, language-agnostic package manager. We provide ROS binaries for Linux, macOS, Windows and ARM (Linux). Installing other recent packages via conda-forge side-by-side works easily, e.g. you can install TensorFlow/PyTorch in the same environment as ROS Noetic without any issues. As no system libraries are used, you can also easily install ROS Noetic on any recent Linux Distribution - including older versions of Ubuntu. As the packages are pre-built, it saves you from compiling from source, which is especially helpful on macOS and Windows. No root access is required, all packages live in your home directory. We have recently written up a [paper](https://arxiv.org/abs/2104.12910) and [blog post](https://medium.com/robostack/cross-platform-conda-packages-for-ros-fa1974fd1de3) with more information.

## Attribution
If you use RoboStack in your academic work, please refer to the following paper:
```
@article{fischer2021robostack,
  title={RoboStack: Using the Robot Operating System alongside the Conda and Jupyter Data Science Ecosystems},
  author={Fischer, Tobias and Vollprecht, Wolf and Traversaro, Silvio and Yen, Sean and Herrero, Carlos and Milford, Michael},
  journal={arXiv preprint arXiv:2104.12910},
  year={2021}
}
```

## Installation

To get started with conda (or mamba) as package managers, you need to have a base conda installation. Please do _not_ use the Anaconda installer, but rather start with [`miniforge` / `mambaforge`](https://github.com/conda-forge/miniforge) or [`miniconda`](https://docs.conda.io/en/latest/miniconda.html), which are much more "minimal" installers. These installers will create a "base" environment that contains the package managers conda (and mamba if you go with `mambaforge`). After this installation is done, you can move on to the next steps.

> Note: Make sure to _not_ install the ROS packages (in particular the `ros-noetic-catkin` package) in your base environment as this leads to issues down the track. On the other hand, conda and mamba must not be installed in the robostackenv, they should only be installed in base. Also do not source the system ROS environment, as the `PYTHONPATH` set in the setup script conflicts with the conda environment.

```bash
conda create -n robostackenv python=3.8
conda activate robostackenv
# this adds the conda-forge channel to the new created environment configuration 
conda config --env --add channels conda-forge
# and the robostack channel
conda config --env --add channels robostack
# it's very much advised to use strict channel priority
conda config --env --set channel_priority strict

# either
conda install ros-noetic-desktop
# or if you have mamba and want to use it
mamba install ros-noetic-desktop

# optionally, install some compiler packages if you want to e.g. build packages in a catkin_ws - with conda:
conda install compilers cmake pkg-config make ninja
# or with mamba:
mamba install compilers cmake pkg-config make ninja

# on linux and osx (but not Windows) you might want to:
mamba install catkin_tools

# on Windows, install the Visual Studio command prompt via Conda:
conda install vs2019_win-64

# note that in this case, you should also install the necessary dependencies with conda/mamba, if possible

# reload environment to activate required scripts before running anything
# on Windows, please restart the Anaconda Prompt / Command Prompt!
conda deactivate
conda activate robostackenv

# if you want to use rosdep, also do:
mamba install rosdep
rosdep init  # note: do not use sudo!
rosdep update
```

**Note: at the moment on Windows only the Command Prompt terminal is supported, while Powershell is not supported.**

## Reporting issues
Feel free to open issues in this repository's [issue tracker](https://github.com/RoboStack/ros-noetic/issues) (please check whether your problem is already listed there before opening a new issue) or come around on [Gitter](https://gitter.im/RoboStack/Lobby) to have a chat / ask questions. Please note that this repository is _not an official distribution of ROS_ and relies on volunteers. It is further highly experimental - unfortunately things might not work immediately out-of-the-box, although we try our best.

## FAQ
#### When running `catkin` or `catkin_make` I get errors that "Multiple packages found with the same name", e.g.
```
/Users/me/miniconda3/envs/robostackenv/share/catkin/cmake/em/order_packages.cmake.em:23: error: <class 'RuntimeError'>: Multiple packages found with the same name "catkin":
- pkgs/ros-noetic-catkin-0.8.10-py38hb43b470_10/share/catkin
- share/catkin
```
You probably installed conda or mamba into your `robostackenv`. However, conda and mamba should only be installed in your `base` environment. Try setting up a new environment without `conda` and `mamba` installed into that environment.

#### When trying to build packages, you get CMake errors that packages could not be found, such as
```
CMake Error at /Users/me/miniconda3/envs/robostackenv/share/catkin/cmake/catkinConfig.cmake:83 (find_package):
  Could not find a package configuration file provided by "std_msgs" with any
  of the following names:

    std_msgsConfig.cmake
    std_msgs-config.cmake
```
First, make sure that the package is installed; in the example case it would be `mamba install ros-noetic-std-msgs`. You can use `rosdep` to install dependencies. Second, make sure that your `CMAKE_PREFIX_PATH` points to your `robostackenv`, in the example case you could achieve this by `export CMAKE_PREFIX_PATH=/Users/me/miniconda3/envs/robostackenv/`. This might happen if `CMAKE_PREFIX_PATH` is not empty when you activate your `robostackenv`.

## Contributing
This project is in early stages and we are looking for contributors to help it grow. Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for ways to contribute.

# RoboStack (for ROS Noetic)

## Why ROS and Conda?
Welcome to RoboStack, which tightly couples ROS with Conda, a cross-platform, language-agnostic package manager. We provide ROS binaries for Linux, OSX, Windows and ARM (Linux). Installing other recent packages via conda-forge side-by-side works easily, e.g. you can install TensorFlow/PyTorch in the same environment as ROS Noetic without any issues. As no system libraries are used, you can also easily install ROS Noetic on any recent Linux Distribution - including older versions of Ubuntu. As the packages are pre-built, it saves you from compiling from source, which is especially helpful on OSX and Windows. No root access is required, all packages live in your home directory.

## Installation

Note: Make sure to _not_ install the ROS packages (in particular the `ros-noetic-catkin` package) in your base environment as this leads to issues down the track.

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

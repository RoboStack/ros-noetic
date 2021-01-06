# Contributing

Many thanks for taking the time to read this and for contributing to RoboStack!

This project is in early stages and we are looking for contributors to help it grow. 
The developers are on [gitter](https://gitter.im/RoboStack/Lobby) where we discuss steps forward.

We welcome all kinds of contribution -- code or non-code -- and value them
highly. We pledge to treat everyones contribution fairly and with respect and
we are here to help awesome pull requests over the finish line.

Please note we have a code of conduct, and follow it in all your interactions with the project.

We follow the [NumFOCUS code of conduct](https://numfocus.org/code-of-conduct).


# Testing changes locally

1. Create a new conda environment and add the conda-forge and robostack channels:
```
conda create -n robostackenv python=3.8
conda activate robostackenv
conda config --append channels defaults
conda config --add channels conda-forge
conda config --add channels robostack
conda config --set channel_priority strict
```
2. Install some dependencies: `conda install pip conda-build anaconda-client mamba conda catkin_pkg ruamel_yaml rosdistro empy networkx requests boa`
3. Install vinca: `pip install git+https://github.com/RoboStack/vinca.git@master --no-deps`
4. Clone this repo: `git clone https://github.com/RoboStack/ros-noetic.git`
5. `cd ros-noetic`
6. `cp vinca_linux_64.yaml vinca.yaml` (replace with your platform as necessary)
7. Modify `vinca.yaml` as you please, e.g. add new packages to be built.
8. Run vinca to generate the recipe by executing `vinca --multiple`
9. Copy the generated recipe to the current folder: `cp recipes/ros-noetic-XXX.yaml recipe.yaml` - note that at least one package needs to be (re)build for this folder to show up. See more info below.
10. Build the recipe using boa: `boa build .`

# How does it work?
- The `vinca.yaml` file specifies which packages should be built. 
  - Add the desired package under `packages_select_by_deps`. This will automatically pull in all dependencies of that package, too.
  - Note that all packages that are already build in one of the channels listed under `skip_existing` will be skipped. You can also add your local channel to that list by e.g. adding `/home/ubuntu/miniconda3/conda-bld/linux-64/repodata.json`. 
  - If you want to manually skip packages, you can list them under `packages_skip_by_deps`.
  - If you set `skip_all_deps` to `True`, you will only build packages listed under `packages_select_by_deps` but none of their dependencies.
  - The `packages_remove_from_deps` list allows you to never build packages, even if they are listed as dependencies of other packages. We use it for e.g. the stage simulator which is not available in conda-forge, but is listed as one of the dependencies of the ros-simulator metapackage.
  - If you want to manually rebuild a package that already exists, you need to comment out the channels listed under `skip_existing`. You probably want to set `skip_all_deps: true`, otherwise all dependencies will be rebuilt in this case.
- If the package does not build successfully out of the box, you might need to patch it. To do so, create a new file `ros-noetic-$PACKAGENAME.patch` in the `patch` directory (replace `$PACKAGENAME$` with the name of the package, and replace any underscores with hyphens). You can also use platform specifiers to only apply the patch on a specific platform, e.g. `ros-noetic-$PACKAGENAME.win.patch`.
- The `conda-forge.yaml` and `packages-ignore.yaml` files are the equivalent of the [rosdep.yaml](http://wiki.ros.org/rosdep/rosdep.yaml) and translate ROS dependencies into conda package names (or in the case of the dependencies listed in `packages-ignore.yaml` the dependencies are ignored by specifying an empty list).

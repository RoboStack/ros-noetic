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
conda create --name robostackenv
conda activate robostackenv
conda config --append channels defaults
conda config --add channels conda-forge
conda config --add channels robostack
conda config --set channel_priority strict
conda update conda -c conda-forge
```
2. Install mamba: `conda install --yes --quiet pip conda-build anaconda-client mamba`
3. Install vinca: `pip install git+https://github.com/RoboStack/vinca.git@master`
4. Install boa: `pip install git+https://github.com/mamba-org/boa.git@master`
5. Clone this repo: `git clone https://github.com/RoboStack/ros-noetic.git`
6. `cd ros-noetic`
7. `cp vinca_linux_64.yaml vinca.yaml` (replace with your platform as necessary)
8. Modify `vinca.yaml` as you please, e.g. add new packages to be built.
9. Run vinca to generate the recipe by executing `vinca --multiple`
10. Copy the generated recipe to the current folder: `cp recipes/ros-noetic-XXX.yaml recipe.yaml`
10. Build the recipe using boa: `boa build .`

If the package does not build successfully out of the box, you might need to patch it. To do so, create a new file `ros-noetic-$PACKAGENAME.patch` in the `patch` directory (replace `$PACKAGENAME$` with the name of the package, and replace any underscores with hyphens). You can also use platform specifiers to only apply the patch on a specific platform, e.g. `ros-noetic-$PACKAGENAME.win.patch`.

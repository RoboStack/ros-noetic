import yaml
import json
import requests
from rich.table import Table
from rich.console import Console

console = Console(record=True)

distro = "noetic"

rosdistro_pkgs = "https://raw.githubusercontent.com/ros/rosdistro/master/{distro}/distribution.yaml".format(distro=distro)
conda_pkgs_url = "https://conda.anaconda.org/robostack/{arch}/repodata.json"

rosdistro_pkgs = yaml.safe_load(requests.get(rosdistro_pkgs).text)

available_pkgs = {}
for reponame, repo in rosdistro_pkgs['repositories'].items():
    if not repo.get('release'):
        available_pkgs[reponame] = None
    elif repo.get('release', {}).get('packages'):
        pkgs = repo['release']['packages']
        for pname in pkgs:
            available_pkgs[pname] = repo['release'].get('version', None)
    else:
        available_pkgs[reponame] = repo['release']['version']

def to_ros(pkg):
    return f"ros-{distro}-{pkg.replace('_', '-')}"

def get_conda_pkgs(arch="linux-64"):
    conda_pkgs = requests.get(conda_pkgs_url.format(arch=arch)).json()
    conda_pkgs_versions = {}
    for pkgname, pkg in conda_pkgs['packages'].items():
        if pkg["name"] in conda_pkgs_versions:
            conda_pkgs_versions[pkg["name"]].add(pkg["version"])
        else:
            conda_pkgs_versions[pkg["name"]] = {pkg["version"]}
    return conda_pkgs_versions

table = Table(show_header=True, header_style="bold magenta")
table.add_column("Package")

availability = {}

def add_arch(arch="linux-64"):
    conda_pkgs_versions = get_conda_pkgs(arch)

    def add_available(arch, pkg, versions=None):
        if pkg in availability:
            availability[pkg][arch] = versions
        else:
            availability[pkg] = {arch: versions}

    for pkg in available_pkgs:
        rpkg = to_ros(pkg)
        if rpkg in conda_pkgs_versions:
            add_available(arch, rpkg, conda_pkgs_versions[rpkg])
        else:
            add_available(arch, rpkg, None)

archs = ('linux-64', 'win-64', 'osx-64', 'linux-aarch64')

for a in archs:
    table.add_column(a)
    add_arch(a)

table.add_column("Versions")
upper_rows, bottom_rows = [], []

for name, pkg in availability.items():
    row = [name]
    versions = set()
    is_upper = False
    for arch in archs:
        if pkg.get(arch):
            row.append("[green]✔")
            is_upper = True
            versions |= pkg[arch]
        else:
            row.append("[red]✖")

    if versions:
        row.append(', '.join(sorted(versions)))
    else:
        row.append('')

    if is_upper:
        upper_rows.append(row)
    else:
        bottom_rows.append(row)

for row in upper_rows:
    table.add_row(*row)
for row in bottom_rows:
    table.add_row(*row)

console.print(table)
console.save_html("version_compare.html")

# import IPython; IPython.embed()
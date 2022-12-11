call activate base

set "PATH=%PATH:C:\ProgramData\Chocolatey\bin;=%"
set "PATH=%PATH:C:\Program Files (x86)\sbt\bin;=%"
set "PATH=%PATH:C:\Rust\.cargo\bin;=%"
set "PATH=%PATH:C:\Program Files\Git\usr\bin;=%"
set "PATH=%PATH:C:\Program Files\Git\cmd;=%"
set "PATH=%PATH:C:\Program Files\Git\mingw64\bin;=%"
set "PATH=%PATH:C:\Program Files (x86)\Subversion\bin;=%"
set "PATH=%PATH:C:\Program Files\CMake\bin;=%"
set "PATH=%PATH:C:\Program Files\OpenSSL\bin;=%"
set "PATH=%PATH:C:\Strawberry\c\bin;=%"
set "PATH=%PATH:C:\Strawberry\perl\bin;=%"
set "PATH=%PATH:C:\Strawberry\perl\site\bin;=%"
set "PATH=%PATH:c:\tools\php;=%"
:: Make paths like C:\\hostedtoolcache\\windows\\Ruby\\2.5.7\\x64\\bin garbage
set "PATH=%PATH:ostedtoolcache=%"

call C:\Miniforge\Scripts\activate.bat base

echo "PATH is %PATH%"
echo "CONDA_BLD_PATH is %CONDA_BLD_PATH%"

rmdir /Q/S C:\Strawberry\

set "FEEDSTOCK_ROOT=%cd%"

mkdir %CONDA_BLD_PATH%
call conda.exe index "%CONDA_BLD_PATH%"

rem call conda config --remove channels defaults
call conda.exe config --add channels conda-forge
call conda.exe config --add channels robostack
call conda.exe config --add channels %CONDA_BLD_PATH%
:: call conda config --set channel_priority strict

:: conda remove --force m2-git

:: C:\Miniconda\python.exe -m pip install git+https://github.com/mamba-org/boa.git@master
call mamba.exe install boa
if errorlevel 1 exit 1

for %%X in (%CURRENT_RECIPES%) do (
    echo "BUILDING RECIPE %%X"
    cd %FEEDSTOCK_ROOT%\recipes\%%X\
    boa build . -m %FEEDSTOCK_ROOT%\.ci_support\conda_forge_pinnings.yaml -m %FEEDSTOCK_ROOT%\conda_build_config.yaml
    if errorlevel 1 exit 1
)

anaconda -t %ANACONDA_API_TOKEN% upload "C:\bld\win-64\*.tar.bz2" --force
if errorlevel 1 exit 1

setlocal EnableExtensions EnableDelayedExpansion
call %CONDA%\condabin\conda_hook.bat
call %CONDA%\condabin\conda.bat activate base

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

echo "PATH is %PATH%"
echo "CONDA_BLD_PATH is %CONDA_BLD_PATH%"

rmdir /Q/S C:\Strawberry\
rmdir /Q/S "C:\Program Files (x86)\Windows Kits\10\Include\10.0.17763.0\"

set "FEEDSTOCK_ROOT=%cd%"

mkdir %CONDA_BLD_PATH%
call conda index %CONDA_BLD_PATH%

rem call conda config --remove channels defaults
call conda config --add channels conda-forge
call conda config --add channels robostack
call conda config --add channels robostack-staging
call conda config --add channels %CONDA_BLD_PATH%
:: call conda config --set channel_priority strict

:: Enable long path names on Windows
reg add HKLM\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled /t REG_DWORD /d 1 /f

:: conda remove --force m2-git

call mamba install boa
if errorlevel 1 exit 1

for %%X in (%CURRENT_RECIPES%) do (
    echo "BUILDING RECIPE %%X"
    cd %FEEDSTOCK_ROOT%\recipes\%%X\
    boa build . -m %FEEDSTOCK_ROOT%\.ci_support\conda_forge_pinnings.yaml -m %FEEDSTOCK_ROOT%\conda_build_config.yaml
    if errorlevel 1 exit 1
)

anaconda -t %ANACONDA_API_TOKEN% upload "C:\bld\win-64\*.tar.bz2" --force
if errorlevel 1 exit 1

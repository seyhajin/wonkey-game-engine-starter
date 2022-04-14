#!/usr/bin/env bash

if [ ! -f "scripts/setup.sh" ]; then
    echo "Invoke this script from the root directory of the checkout."
    echo ""
    echo "FAILED!"
    exit 1
fi

#----------------------------------------------------------------------------------------

echo "#"
echo "# Checking prerequisite tools"
echo "#"

echo

#----------------------------------------------

echo - `git --version`
if [ $? -ne 0 ]; then
    echo
    echo "Failed to check 'git' -- is it installed?"
    echo
    echo "FAILED!"
    exit 1
fi

#----------------------------------------------

echo - `cmake --version`
if [ $? -ne 0 ]; then
    echo
    echo "Failed to check 'cmake' -- is it installed?"
    echo
    echo "FAILED!"
    exit 1
fi

#----------------------------------------------

echo - ninja version `ninja --version`
if [ $? -ne 0 ]; then
    echo
    echo "Failed to check 'ninja' -- is it installed?"
    echo
    echo "FAILED!"
    exit 1
fi

#----------------------------------------------

echo

#----------------------------------------------------------------------------------------

echo "#"
echo "# Setting up repository at '$PWD'"
echo "#"

#----------------------------------------------

if [ ! -d "deps/depot_tools" ]; then
    echo
    echo "# Checking out 'depot_tools' sources at 'deps/depot_tools'"
    echo
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git deps/depot_tools
    if [ $? -ne 0 ]; then
        echo
        echo "FAILED!"
        echo
    fi
else
    echo
    echo "'deps/depot_tools' directory is already exist."
fi

#----------------------------------------------

if [ ! -d "deps/angle" ]; then
    echo
    echo "# Checking out 'angle' sources at 'deps/angle'"
    echo
    git clone https://github.com/google/angle deps/angle
    if [ $? -ne 0 ]; then
        echo
        echo "FAILED!"
        echo
    fi
else
    echo
    echo "'deps/angle' directory is already exist."
fi

#----------------------------------------------

if [ ! -d "deps/sdl" ]; then
    echo
    echo "# Checking out 'sdl' sources at 'deps/sdl'"
    echo
    git clone https://github.com/libsdl-org/SDL.git deps/sdl
    if [ $? -ne 0 ]; then
        echo
        echo "FAILED!"
        echo
    fi
else
    echo
    echo "'deps/depot_tools' directory is already exist."
fi

#----------------------------------------------------------------------------------------

echo 
echo "Setup finished -- ready to syncying dependencies with './scripts/sync.sh'"
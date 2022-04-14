#!/usr/bin/env bash

if [ ! -f "scripts/sync.sh" ]; then
    echo "Invoke this script from the root directory of the checkout."
    echo ""
    echo "FAILED!"
    exit 1
fi

#----------------------------------------------------------------------------------------

echo "#"
echo "# Fetching dependencies (this may take a long time, the first time)"
echo "#"

depot_tools="$PWD/deps/depot_tools"
export PATH="${depot_tools}:$PATH"

echo
echo "# Verifying 'depot_tools/gclient' version (this may download additional tools)"
echo
${depot_tools}/gclient --version

#----------------------------------------------

cp -vf deps/angle.gclient deps/angle/.gclient

pushd deps/angle

# revert patches
git checkout HEAD .

# gclient opts:
#   --shallow             GIT ONLY - Do a shallow clone into the cache dir.
#   --no-history          GIT ONLY - Reduces the size/time of the checkout at the cost of no history.
#   -D, --delete_unversioned_trees
#                         Deletes from the working copy any dependencies that
#                         have been removed since the last sync, as long as
#                         there are no local modifications.
#   -R, --reset           resets any local changes before updating (git only)
#   -f, --force           force update even for unchanged modules
gclient sync --shallow --no-history -D -R --force

if [ $? -ne 0 ]; then
    echo
    echo "GClient failed!"
    exit 1
fi

popd

#----------------------------------------------

pushd deps/sdl

# revert patches
git checkout HEAD .

popd

#----------------------------------------------------------------------------------------

echo
echo "# Patching dependencies"
echo

# apply patches
git apply -v --directory deps/angle deps/angle.patch
git apply -v --directory deps/sdl deps/sdl.patch

if [ $? -ne 0 ]; then
    echo
    echo "Patching failed!"
    exit 1
fi

#----------------------------------------------------------------------------------------

echo
echo "# Saving dependency revisions"
echo

rm -rf deps.txt

echo "angle: `git -C deps/angle rev-parse HEAD`" >> deps.txt
echo "sdl: `git -C deps/sdl rev-parse HEAD`" >> deps.txt
echo "Saved in 'deps.txt'"

#----------------------------------------------------------------------------------------

echo 
echo "Syncying finished -- ready to building dependencies with './scripts/build.sh'"
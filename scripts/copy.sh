#!/usr/bin/env bash

if [ ! -f "scripts/copy.sh" ]; then
    echo "Invoke this script from the root directory of the checkout."
    echo ""
    echo "FAILED!"
    exit 1
fi

#----------------------------------------------------------------------------------------

echo "#"
echo "# Copying headers to 'include' directory"
echo "#"

mkdir -p native/include/{EGL,GLES2,GLES3,KHR}

cp -pvr deps/angle/include/EGL native/include
cp -pvr deps/angle/include/GLES2 native/include
cp -pvr deps/angle/include/GLES3 native/include
cp -pvr deps/angle/include/KHR native/include

mkdir -p native/include/SDL2

cp -pvr deps/sdl/include/*.h native/include/SDL2

#----------------------------------------------

echo "#"
echo "# Copying libraries to 'lib' directory"
echo "#"

mkdir -p native/lib/macos

cp -pv deps/angle/out/Release/obj/libEGL_static.a native/lib/macos
cp -pv deps/sdl/build/Release/*.a native/lib/macos

#----------------------------------------------

echo "#"
echo "# Cleaning headers and librairies directories"
echo "#"

find ./native/include -name '*.md' -delete
find ./native/include -name '.clang-format' -delete
find ./native/include/SDL2 -name 'SDL_test*.h' -delete

echo "Cleaning done."

#----------------------------------------------------------------------------------------

echo 
echo "Copying finished -- ready to develop!"
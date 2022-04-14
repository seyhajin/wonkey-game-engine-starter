#!/usr/bin/env bash

if [ ! -f "scripts/build.sh" ]; then
    echo "Invoke this script from the root directory of the checkout."
    echo ""
    echo "FAILED!"
    exit 1
fi

#----------------------------------------------------------------------------------------

echo "#"
echo "# Building dependencies"
echo "#"

depot_tools="$PWD/deps/depot_tools"
export PATH="${depot_tools}:$PATH"

#----------------------------------------------

echo
echo "# Building 'angle'"
echo

pushd deps/angle

mkdir -p out/Release

if [ "`uname`" = "Darwin" ]; then
    # macos args.gn
    gn gen out/Release --args=" \
        is_component_build=false \
        target_cpu=\"x64\" \
        is_debug=false \
        angle_assert_always_on=false \
        dcheck_always_on=false \
        dcheck_is_configurable=false \
        use_custom_libcxx=false \
        clang_use_chrome_plugins=false \
        symbol_level=0 \
        angle_build_vulkan_system_info=false \
        angle_debug_layers_enabled=false \
        angle_build_all=false \
        angle_enable_d3d11=false \
        angle_enable_d3d9=false \
        angle_enable_gl=true \
        angle_enable_gl_desktop=true \
        angle_enable_null=false \
        angle_enable_vulkan=false \
        angle_enable_metal=true \
        "
else
    # linux args.gn
    gn gen out/Release --args=" \
        is_component_build=false \
        target_cpu=\"x64\" \
        is_debug=false \
        angle_assert_always_on=false \
        dcheck_always_on=false \
        dcheck_is_configurable=false \
        use_custom_libcxx=false \
        clang_use_chrome_plugins=false \
        symbol_level=0 \
        angle_build_vulkan_system_info=false \
        angle_debug_layers_enabled=false \
        angle_build_all=false \
        angle_enable_d3d11=false \
        angle_enable_d3d9=false \
        angle_enable_gl=true \
        angle_enable_gl_desktop=true \
        angle_enable_null=false \
        angle_enable_vulkan=false \
        angle_enable_metal=false \
        "
fi

# windows args.gn
#gn gen out/Release --args=" \
#    is_component_build=false \
#    target_cpu=\"x64\" \
#    is_debug=false \
#    angle_assert_always_on=false \
#    dcheck_always_on=false \
#    dcheck_is_configurable=false \
#    use_custom_libcxx=false \
#    clang_use_chrome_plugins=false \
#    symbol_level=0 \
#    angle_build_vulkan_system_info=false \
#    angle_debug_layers_enabled=false \
#    angle_build_all=false \
#    angle_enable_d3d11=true \
#    angle_enable_d3d9=false \
#    angle_enable_gl=false \
#    angle_enable_gl_desktop=false \
#    angle_enable_null=false \
#    angle_enable_vulkan=false \
#    angle_enable_metal=false \
#    "

if [ $? -ne 0 ]; then
    echo
    echo "GN failed!"
    exit 1
fi

ninja -C out/Release libEGL_static

if [ $? -ne 0 ]; then
    echo
    echo "Ninja failed!"
    exit 1
fi

popd

#----------------------------------------------

echo
echo "# Building 'sdl'"
echo

pushd deps/sdl

mkdir -p build/Release

pushd build/Release

cmake -G Ninja \
    -DSDL_STATIC_ANGLE=ON \
    -DSDL_SHARED=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    ../..

ninja

popd

popd

#----------------------------------------------------------------------------------------

echo 
echo "Building finished -- ready to use dependencies!"
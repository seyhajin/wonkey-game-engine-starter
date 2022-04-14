# Update from b120ab6d49f48c9809a33ef522ce4e1eed79be22 (chromium/4998)

vars = {
  'angle_git': 'https://github.com/google/angle.git',
  'angle_commit': 'b120ab6d49f48c9809a33ef522ce4e1eed79be22',
}

# ANGLE dependencies. Copied from deps/angle/DEPS.
angle_deps = {
  'build': 'https://chromium.googlesource.com/chromium/src/build.git@2c3758a417ccaba55f88e4f65a237e5db3a48211',
  'testing': 'https://chromium.googlesource.com/chromium/src/testing@75cd8f7f15d4b8f05d4b7f795396f30a71e21ec6',
  'third_party/abseil-cpp': 'https://chromium.googlesource.com/chromium/src/third_party/abseil-cpp@ef6cda34631acea9c51a5fa6c27f2ccd2942ba14',
  'third_party/catapult': 'https://chromium.googlesource.com/catapult.git@4326c47b24f7e3c58010e97f31d176bf960c5182',
  'third_party/jsoncpp': 'https://chromium.googlesource.com/chromium/src/third_party/jsoncpp@30a6ac108e24dabac7c2e0df4d33d55032af4ee7',
  'third_party/libjpeg_turbo': 'https://chromium.googlesource.com/chromium/deps/libjpeg_turbo.git@22f1a22c99e9dde8cd3c72ead333f425c5a7aa77',
  'third_party/nasm': 'https://chromium.googlesource.com/chromium/deps/nasm.git@9215e8e1d0fe474ffd3e16c1a07a0f97089e6224',
  'third_party/protobuf': 'https://chromium.googlesource.com/chromium/src/third_party/protobuf@b3054f7a3ac48d9751ef02f380678d3f81ab6327',
  'third_party/SwiftShader': 'https://swiftshader.googlesource.com/SwiftShader@d15c42482560fba311e3cac90203438ad972df55',
  'third_party/vulkan_memory_allocator': 'https://chromium.googlesource.com/external/github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator@5e49f57a6e71a026a54eb42e366de09a4142d24e',
  'third_party/zlib': 'https://chromium.googlesource.com/chromium/src/third_party/zlib@c61f2678661a78b3fd84ee5afe490da498a0fb47',
  'tools/clang': 'https://chromium.googlesource.com/chromium/src/tools/clang.git@3eacd6cee13a8e9a86a74fcaa5532eeb3aec676c',
  'tools/protoc_wrapper': 'https://chromium.googlesource.com/chromium/src/tools/protoc_wrapper@c16b0dc8db35e95a04eaef88079237634c7f20c2',

  # vulkan-deps
  'third_party/vulkan-deps': 'https://chromium.googlesource.com/vulkan-deps@345e2a278e690d353bd9ac45304d0eb88c5a3f62',
  'third_party/vulkan-deps/glslang/src': 'https://chromium.googlesource.com/external/github.com/KhronosGroup/glslang@abbe466451ca975fecfdba453ef9073df52aefc5',
  'third_party/vulkan-deps/spirv-cross/src': 'https://chromium.googlesource.com/external/github.com/KhronosGroup/SPIRV-Cross@0d4ce028bf8b8a94d325dc1e1c20446153ba19c4',
  'third_party/vulkan-deps/spirv-headers/src': 'https://chromium.googlesource.com/external/github.com/KhronosGroup/SPIRV-Headers@4995a2f2723c401eb0ea3e10c81298906bf1422b',
  'third_party/vulkan-deps/spirv-tools/src': 'https://chromium.googlesource.com/external/github.com/KhronosGroup/SPIRV-Tools@b0ce31fd2d8fdf0bdf87832a63d3da3289202fdf',
  'third_party/vulkan-deps/vulkan-headers/src': 'https://chromium.googlesource.com/external/github.com/KhronosGroup/Vulkan-Headers@0c5928795a66e93f65e5e68a36d8daa79a209dc2',
  'third_party/vulkan-deps/vulkan-loader/src': 'https://chromium.googlesource.com/external/github.com/KhronosGroup/Vulkan-Loader@f8c97eea2faf43cac6d8b396d0ed3a88ae753490',
  'third_party/vulkan-deps/vulkan-tools/src': 'https://chromium.googlesource.com/external/github.com/KhronosGroup/Vulkan-Tools@e494de740e1b64996e9ceee81ee084768ec3e70a',
  'third_party/vulkan-deps/vulkan-validation-layers/src': 'https://chromium.googlesource.com/external/github.com/KhronosGroup/Vulkan-ValidationLayers@41eacec7dd42e5bb66fd30c68bd61529a2efd5f1',
}

solutions = [
  {
    "name": ".",
    "url": None,
    "managed": False,
    "custom_deps": {
      #".": vars['angle_git'] + '@' + vars['angle_commit'],
    },
  },
]

for (k, v) in angle_deps.items():
  solutions[0]['custom_deps']['./' + k] = v
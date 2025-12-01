PKG_NAME = vc-intrinsics
PKG_VERS = 0.24.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = vc-intrinsics-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/vc-intrinsics/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/intel/vc-intrinsics
COMMENT = Contains a set of new intrinsics on top of core LLVM IR instructions that represent SIMD semantics of a program targeting GPU.
LICENSE = MIT

BUILD_DEPENDS   = cross/llvm-project-140.src
NATIVE_DEPENDS += native/llvm-140
NATIVE_DEPENDS += native/Khronos-SPIRV-LLVM-Translator-140

# Allow vc-intrinsics to be built out-of-tree from intel-opencl-clang
export VC_INTRINSICS_IN_TREE_INSTALL=FALSE

# External build: To configure VC Intrinsics with prebuilt LLVM
CMAKE_ARGS += -DLLVM_DIR=$(WORK_DIR)/../../llvm-14.0-build/work-native/install/usr/local/lib/cmake/llvm
CMAKE_ARGS += -DBUILD_SHARED_LIBS=ON

include ../../mk/spksrc.native-cmake.mk

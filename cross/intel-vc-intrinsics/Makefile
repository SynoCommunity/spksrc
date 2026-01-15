PKG_NAME = vc-intrinsics
PKG_VERS = 0.24.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = vc-intrinsics-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/vc-intrinsics/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/intel/vc-intrinsics
COMMENT = Contains a set of new intrinsics on top of core LLVM IR instructions that represent SIMD semantics of a program targeting GPU.
LICENSE = MIT

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

BUILD_DEPENDS += cross/llvm-project-140.src
DEPENDS = cross/Khronos-SPIRV-LLVM-Translator-140

# Allow vc-intrinsics to be built out-of-tree from intel-opencl-clang
export VC_INTRINSICS_IN_TREE_INSTALL=FALSE

# External build: To configure VC Intrinsics with prebuilt LLVM
CMAKE_ARGS += -DLLVM_DIR=$(STAGING_INSTALL_PREFIX)/lib/cmake/llvm

POST_EXTRACT_TARGET = vc-intrinsics_post_extract_target
vc-intrinsics_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) $(PKG_NAME)

include ../../mk/spksrc.cross-cmake.mk

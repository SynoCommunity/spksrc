PKG_NAME = vc-intrinsics
PKG_VERS = 0.19.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = vc-intrinsics-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/vc-intrinsics/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/intel/vc-intrinsics
COMMENT = Contains a set of new intrinsics on top of core LLVM IR instructions that represent SIMD semantics of a program targeting GPU.
LICENSE = MIT

DEPENDS = cross/intel-opencl-clang-140

POST_EXTRACT_TARGET = vc-intrinsics_post_extract_target
USE_NATIVE_CMAKE = 1

# External build: To configure VC Intrinsics with prebuilt LLVM
CMAKE_ARGS += -DLLVM_DIR=$(STAGING_INSTALL_PREFIX)/lib/cmake/llvm

include ../../mk/spksrc.cross-cmake.mk

.PHONY: vc-intrinsics_post_extract_target
vc-intrinsics_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) $(PKG_NAME)

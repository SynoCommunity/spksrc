PKG_NAME = vc-intrinsics
PKG_VERS = 0.20.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = vc-intrinsics-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/vc-intrinsics/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/intel/vc-intrinsics
COMMENT = Contains a set of new intrinsics on top of core LLVM IR instructions that represent SIMD semantics of a program targeting GPU.
LICENSE = MIT

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = nop

POST_EXTRACT_TARGET = vc-intrinsics_post_extract_target

include ../../mk/spksrc.cross-cmake.mk

.PHONY: vc-intrinsics_post_extract_target
vc-intrinsics_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) $(PKG_NAME)

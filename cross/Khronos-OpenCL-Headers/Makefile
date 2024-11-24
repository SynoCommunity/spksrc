PKG_NAME = OpenCL-Headers
PKG_VERS = 2024.05.08
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = khronos-opencl-headers-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/KhronosGroup/OpenCL-Headers/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/KhronosGroup/SPIRV-Headers
COMMENT = Machine-readable files for the SPIR-V Registry
LICENSE = Copyright (c) 2015-2024 The Khronos Group Inc.

POST_EXTRACT_TARGET = SPIRV-Headers_post_extract_target

include ../../mk/spksrc.cross-cmake.mk

.PHONY: SPIRV-Headers_post_extract_target
SPIRV-Headers_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) $(PKG_NAME)

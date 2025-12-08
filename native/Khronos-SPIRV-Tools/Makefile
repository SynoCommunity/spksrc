PKG_NAME = SPIRV-Tools
PKG_VERS = 2025.4
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/KhronosGroup/SPIRV-Tools
COMMENT = The SPIR-V Tools project provides an API and commands for processing SPIR-V modules.
LICENSE = Apache-2.0 license

NATIVE_DEPENDS = native/Khronos-SPIRV-Headers

POST_EXTRACT_TARGET = SPIRV-Tools_post_extract_target

CMAKE_ARGS += -DSPIRV_WERROR=OFF
CMAKE_ARGS += -DSPIRV_TOOLS_BUILD_STATIC=OFF
CMAKE_ARGS += -DSPIRV-Headers_SOURCE_DIR=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.native-cmake.mk

.PHONY: SPIRV-Tools_post_extract_target

SPIRV-Tools_post_extract_target:
	@cd $(WORK_DIR) && ln -sf $(PKG_DIR) $(PKG_NAME)

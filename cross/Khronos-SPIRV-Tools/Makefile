PKG_NAME = SPIRV-Tools
PKG_VERS = 2024.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/KhronosGroup/SPIRV-Tools
COMMENT = The SPIR-V Tools project provides an API and commands for processing SPIR-V modules.
LICENSE = Apache-2.0 license

BUILD_DEPENDS = cross/Khronos-SPIRV-Headers

POST_EXTRACT_TARGET = SPIRV-Tools_post_extract_target

CMAKE_ARGS += -DSPIRV_WERROR=OFF
CMAKE_ARGS += -DSPIRV_TOOLS_BUILD_STATIC=OFF
CMAKE_ARGS += -DSPIRV-Headers_SOURCE_DIR=$(WORK_DIR)/SPIRV-Headers

include ../../mk/spksrc.cross-cmake.mk

# Using gcc-8 we must use: make LDLIBS=-lstdc++fs
# or by adding the following
ifeq ($(call version_le, $(TC_GCC), 9),1)
CMAKE_ARGS += -DCMAKE_CXX_STANDARD_LIBRARIES=-lstdc++fs
endif

.PHONY: SPIRV-Tools_post_extract_target
SPIRV-Tools_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) $(PKG_NAME)

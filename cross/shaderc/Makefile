PKG_NAME = shaderc
PKG_VERS = 2026.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/google/shaderc/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/google/shaderc
COMMENT  = A collection of tools, libraries and tests for shader compilation.
LICENSE  = Apache License Version 2.0

DEPENDS = cross/Khronos-glslang cross/Khronos-SPIRV-Tools

CMAKE_ARGS += -DSHADERC_SKIP_TESTS=ON
CMAKE_ARGS += -DSHADERC_SKIP_EXAMPLES=ON
CMAKE_ARGS += -DSHADERC_SKIP_COPYRIGHT_CHECK=ON
CMAKE_ARGS += -DALLOW_EXTERNAL_SPIRV_TOOLS=ON
CMAKE_ARGS += -DSHADERC_GLSLANG_DIR=$(WORK_DIR)/glslang
CMAKE_ARGS += -DSHADERC_SPIRV_HEADERS_DIR=$(WORK_DIR)/SPIRV-Headers
CMAKE_ARGS += -DSHADERC_SPIRV_TOOLS_DIR=$(WORK_DIR)/SPIRV-Tools
CMAKE_ARGS += -DSPIRV_TOOLS_BUILD_STATIC=OFF

include ../../mk/spksrc.common.mk

# std::filesystem integration to libstdc++ >= GCC 9
ifeq ($(call version_lt, $(TC_GCC), 9),1)
CMAKE_ARGS += -DCMAKE_CXX_STANDARD_LIBRARIES=-lstdc++fs
endif

include ../../mk/spksrc.cross-cmake.mk

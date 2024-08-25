PKG_NAME = compute-runtime
PKG_VERS = 24.26.30049.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/compute-runtime/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/intel/compute-runtime
COMMENT = The Intel(R) Graphics Compute Runtime for oneAPI Level Zero and OpenCL(TM) Driver is an open source project providing compute API support (Level Zero, OpenCL) for Intel graphics hardware architectures (HD Graphics, Xe).
LICENSE = MIT license

POST_EXTRACT_TARGET = intel-compute-runtime_post_extract_target
CMAKE_USE_NINJA = 0

DEPENDS  = cross/intel-gmmlib
DEPENDS += cross/intel-graphics-compiler

#CMAKE_BUILD_DIR = $(WORK_DIR)/igc.build
#CMAKE_SOURCE_DIR = $(WORK_DIR)/igc
CMAKE_DIR = $(WORK_DIR)/$(PKG_DIR)/neo

# [Khronos-OpenCL-Headers]
BUILD_DEPENDS += cross/Khronos-OpenCL-Headers

# [Khronos-SPIRV-Headers]
BUILD_DEPENDS += cross/Khronos-SPIRV-Headers

# Requires building mesa to get OpenGL
#CMAKE_ARGS += -DKHRONOS_GL_HEADERS_DIR=$(STAGING_INSTALL_PREFIX)/include
CMAKE_ARGS += -DKHRONOS_HEADERS_DIR=$(STAGING_INSTALL_PREFIX)/include
CMAKE_ARGS += -DIGC_DIR=$(STAGING_INSTALL_PREFIX)/include
CMAKE_ARGS += -DNEO_DISABLE_LD_GOLD:BOOL=ON
CMAKE_ARGS += -DSKIP_UNIT_TESTS=1

include ../../mk/spksrc.cross-cmake.mk

.PHONY: intel-compute-runtime_post_extract_target
intel-compute-runtime_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) $(PKG_NAME)

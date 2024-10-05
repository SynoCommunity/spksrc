PKG_NAME = compute-runtime
PKG_VERS = 24.31.30508.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/compute-runtime/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

HOMEPAGE = https://github.com/intel/compute-runtime
COMMENT = The Intel(R) Graphics Compute Runtime for oneAPI Level Zero and OpenCL(TM) Driver is an open source project providing compute API support (Level Zero, OpenCL) for Intel graphics hardware architectures (HD Graphics, Xe).
LICENSE = MIT license

POST_EXTRACT_TARGET = intel-compute-runtime_post_extract_target
CMAKE_USE_NINJA = 0

DEPENDS  = cross/intel-gmmlib
DEPENDS += cross/intel-graphics-compiler

# [Khronos-OpenCL-Headers]
BUILD_DEPENDS += cross/Khronos-OpenCL-Headers
CMAKE_ARGS += -DKHRONOS_HEADERS_DIR=$(STAGING_INSTALL_PREFIX)/include

# [Khronos-SPIRV-Headers]
BUILD_DEPENDS += cross/Khronos-SPIRV-Headers

CMAKE_ARGS += -DIGC_DIR=$(STAGING_INSTALL_PREFIX)
CMAKE_ARGS += -DNEO_DISABLE_LD_GOLD:BOOL='ON'
CMAKE_ARGS += -DSKIP_UNIT_TESTS=1
CMAKE_ARGS += -DOCL_ICD_VENDORDIR=$(INSTALL_PREFIX)/etc/OpenCL/vendors/

include ../../mk/spksrc.cross-cmake.mk

ENV += LD_LIBRARY_PATH=$(STAGING_INSTALL_PREFIX)/lib

.PHONY: intel-compute-runtime_post_extract_target
intel-compute-runtime_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) $(PKG_NAME)

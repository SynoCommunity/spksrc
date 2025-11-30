PKG_NAME = compute-runtime
# Last version compatible with Gen9
PKG_VERS = 24.35
PKG_EXT = tar.gz
PKG_DIST_SITE = https://github.com/intel/compute-runtime/archive

# Use last git commit from releases/24.35 branch:
# https://github.com/intel/compute-runtime/blob/master/BUILD.md#optional---building-neo-with-support-for-gen8-gen9-and-gen11-devices
#
# git clone git@github.com:intel/compute-runtime.git
# cd compute-runtime && git checkout releases/24.35
# git rev-parse HEAD
#    6595ef08f71c8a23806aaf1cdde783bc449ec4e0

PKG_GIT_BRANCH = release/$(PKG_VERS)
PKG_GIT_HASH = 6595ef08f71c8a23806aaf1cdde783bc449ec4e0
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

HOMEPAGE = https://github.com/intel/compute-runtime
COMMENT = The Intel(R) Graphics Compute Runtime for oneAPI Level Zero and OpenCL(TM) Driver is an open source project providing compute API support (Level Zero, OpenCL) for Intel graphics hardware architectures (HD Graphics, Xe).
LICENSE = MIT license

POST_EXTRACT_TARGET = intel-compute-runtime_post_extract_target

DEPENDS  = cross/intel-gmmlib
DEPENDS += cross/intel-graphics-compiler

# [Khronos-OpenCL-Headers]
BUILD_DEPENDS  = cross/Khronos-OpenCL-Headers
CMAKE_ARGS += -DKHRONOS_HEADERS_DIR=$(STAGING_INSTALL_PREFIX)/include

# [Khronos-SPIRV-Headers]
BUILD_DEPENDS += cross/Khronos-SPIRV-Headers

CMAKE_ARGS += -DIGC_DIR=$(STAGING_INSTALL_PREFIX)
CMAKE_ARGS += -DNEO_DISABLE_LD_GOLD:BOOL='ON'
CMAKE_ARGS += -DSKIP_UNIT_TESTS=1
CMAKE_ARGS += -DOCL_ICD_VENDORDIR=$(INSTALL_PREFIX)/etc/OpenCL/vendors/
CMAKE_ARGS += -DNEO_LEGACY_PLATFORMS_SUPPORT=1
CMAKE_ARGS += -DNEO_CURRENT_PLATFORMS_SUPPORT=0

include ../../mk/spksrc.cross-cmake.mk

ENV += LD_LIBRARY_PATH=$(STAGING_INSTALL_PREFIX)/lib

.PHONY: intel-compute-runtime_post_extract_target
intel-compute-runtime_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) $(PKG_NAME)

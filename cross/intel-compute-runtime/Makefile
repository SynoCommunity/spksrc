PKG_NAME = compute-runtime
# Last maintained branch 24.35 with Gen8-9-11-12 support
PKG_VERS = 24.35.30872.41
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/compute-runtime/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Use last git commit from releases/24.35 branch:
# https://github.com/intel/compute-runtime/blob/master/BUILD.md#optional---building-neo-with-support-for-gen8-gen9-and-gen11-devices
#
# git clone git@github.com:intel/compute-runtime.git
# cd compute-runtime && git checkout releases/24.35
# git rev-parse HEAD
#    6595ef08f71c8a23806aaf1cdde783bc449ec4e0
#PKG_GIT_BRANCH = release/$(PKG_VERS)
#PKG_GIT_HASH = 6595ef08f71c8a23806aaf1cdde783bc449ec4e0
#PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
#PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
#PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

HOMEPAGE = https://github.com/intel/compute-runtime
COMMENT = The Intel(R) Graphics Compute Runtime for oneAPI Level Zero and OpenCL(TM) Driver is an open source project providing compute API support (Level Zero, OpenCL) for Intel graphics hardware architectures (HD Graphics, Xe).
LICENSE = MIT license

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
BUILD_DEPENDS  = cross/libglvnd
BUILD_DEPENDS += cross/Khronos-OpenCL-Headers
BUILD_DEPENDS += cross/Khronos-SPIRV-Headers
DEPENDS  = cross/Khronos-SPIRV-LLVM-Translator-140
DEPENDS += cross/intel-graphics-compiler
DEPENDS += cross/intel-level-zero
DEPENDS += cross/intel-gmmlib

# -----------------------------------------------------------------------------
# Post-extract: create symlink so LLVM can find the translator
# -----------------------------------------------------------------------------
POST_EXTRACT_TARGET = intel-compute-runtime_post_extract_target
intel-compute-runtime_post_extract_target:
	@cd $(WORK_DIR) && ln -s $(PKG_DIR) $(PKG_NAME)

POST_INSTALL_TARGET = intel-compute-runtime_post_install_target
intel-compute-runtime_post_install_target:
	@cd $(STAGING_INSTALL_PREFIX)/bin && ln -s ocloc-24.35.0 ocloc

# -----------------------------------------------------------------------------
# CMake arguments
# -----------------------------------------------------------------------------
CMAKE_ARGS += -DIGC_DIR=$(STAGING_INSTALL_PREFIX)
CMAKE_ARGS += -DSKIP_UNIT_TESTS=1
CMAKE_ARGS += -DOCL_ICD_VENDORDIR=$(INSTALL_PREFIX)/etc/OpenCL/vendors/
CMAKE_ARGS += -DNEO_DISABLE_LD_GOLD:BOOL='ON'
CMAKE_ARGS += -DL0_INSTALL_UDEV_RULES='OFF'
CMAKE_ARGS += -DCOMPILE_BUILT_INS='ON'
# Reduce build size, support up to Gen9.5, uses _legacy1 suffix
CMAKE_ARGS += -DNEO_LEGACY_PLATFORMS_SUPPORT='ON'
CMAKE_ARGS += -DNEO_CURRENT_PLATFORMS_SUPPORT='OFF'

# [OpenCL/GL-Headers]
CMAKE_ARGS += -DKHRONOS_GL_HEADERS_DIR=$(STAGING_INSTALL_PREFIX)/include
CMAKE_ARGS += -DKHRONOS_HEADERS_DIR=$(STAGING_INSTALL_PREFIX)/include

# -----------------------------------------------------------------------------
# Reduce build-time binary size
# -----------------------------------------------------------------------------
GCC_NO_DEBUG_INFO = 1

# -----------------------------------------------------------------------------
# Include the common cross-cmake rules
# -----------------------------------------------------------------------------
include ../../mk/spksrc.cross-cmake.mk

PKG_NAME = intel-media
# Last supported version to match gmmlib 22.5
PKG_VERS = 24.4.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/media-driver/archive
PKG_DIR = media-driver-$(PKG_NAME)-$(PKG_VERS)
# DEBUG: For manual git-bisect
# git log --pretty=oneline intel-media-22.1.0 intel-media-22.1.1
#PKG_GIT_HASH = 019f74c0d893e6e2b799121147357d7ebbf30998
#PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
#PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
#PKG_DIR = media-driver-$(PKG_GIT_HASH)

DEPENDS = cross/intel-gmmlib
REQUIRED_MIN_DSM = 7
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

# https://en.wikipedia.org/wiki/Tick%E2%80%93tock_model
HOMEPAGE = https://github.com/intel/media-driver
COMMENT  = The Intel Media Driver for VAAPI is a new VA-API (Video Acceleration API) user mode driver supporting hardware accelerated decoding, encoding, and video post processing for GEN based graphics hardware.
LICENSE  = MIT

CMAKE_USE_DESTDIR = 0

# Limit compile/link-time storage space (and faster build-time)
GCC_NO_DEBUG_INFO = 1

include ../../mk/spksrc.cross-cmake.mk

# intel-media-driver specific args
# for succesfull build
CONFIGURE_ARGS += -DCMAKE_INSTALL_PREFIX=$(WORK_DIR)/install/$(INSTALL_PREFIX)
CONFIGURE_ARGS += -DMEDIA_RUN_TEST_SUITE=OFF
CONFIGURE_ARGS += -Wno-dev

# Reduce build-time binary size
GCC_NO_DEBUG_INFO = 1

# Deactivate unecessary GPU generations (only Gen8/Gen9 needed)
#CONFIGURE_ARGS += -DGEN8=OFF
#CONFIGURE_ARGS += -DGEN11=OFF
#CONFIGURE_ARGS += -DGEN12=OFF
#CONFIGURE_ARGS += -DMTL=OFF
#CONFIGURE_ARGS += -DARL=OFF
#CONFIGURE_ARGS += -DLNL=OFF
#CONFIGURE_ARGS += -DBMG=OFF
#CONFIGURE_ARGS += -DPTL=OFF

PKG_NAME = intel-media
PKG_VERS = 22.4.4
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

DEPENDS = cross/gmmlib
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

HOMEPAGE = https://github.com/intel/media-driver
COMMENT  = The Intel Media Driver for VAAPI is a new VA-API (Video Acceleration API) user mode driver supporting hardware accelerated decoding, encoding, and video post processing for GEN based graphics hardware.
LICENSE  = MIT

CMAKE_USE_DESTDIR = 0

include ../../mk/spksrc.cross-cmake.mk

# intel-media-driver specific args
# for succesfull build
CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(WORK_DIR)/install/$(INSTALL_PREFIX)
CMAKE_ARGS += -DMEDIA_RUN_TEST_SUITE=OFF
CMAKE_ARGS += -Wno-dev

# Flags to be added to CMake toolchain file
ifeq ($(call version_lt, ${TC_GCC}, 5),1)
ADDITIONAL_CFLAGS += -Wno-error=delete-incomplete
ADDITIONAL_CXXFLAGS += -std=c++11
endif

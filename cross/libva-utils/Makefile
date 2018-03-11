PKG_NAME = libva-utils
PKG_VERS = 2.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/libva-utils/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libva

HOMEPAGE = https://01.org/linuxmedia
COMMENT = Libva-utils is a collection of tests for VA-API (Video Acceleration API)
LICENSE = MIT

PRE_CONFIGURE_TARGET = libva_utils_configure

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: libva_utils_configure
libva_utils_configure:
	$(RUN) ./autogen.sh

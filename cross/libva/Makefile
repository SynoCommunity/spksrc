PKG_NAME = libva
PKG_VERS = 2.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/libva/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libdrm

HOMEPAGE = https://01.org/vaapi
COMMENT  = Libva is an implementation for VA-API (Video Acceleration API).
LICENSE = MIT

PRE_CONFIGURE_TARGET = libva_custom_preconfigure

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: libva_custom_preconfigure
libva_custom_preconfigure:
	$(RUN) ./autogen.sh

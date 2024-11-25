PKG_NAME = libva
PKG_VERS = 2.22.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/libva/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libdrm

HOMEPAGE = https://01.org/vaapi
COMMENT  = Libva is an implementation for VA-API (Video Acceleration API).
LICENSE  = MIT

CONFIGURE_ARGS = -Ddriverdir=$(INSTALL_PREFIX)/lib

include ../../mk/spksrc.cross-meson.mk

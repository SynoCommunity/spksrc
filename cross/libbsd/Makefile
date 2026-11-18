PKG_NAME = libbsd
PKG_VERS = 0.12.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://libbsd.freedesktop.org/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libmd

HOMEPAGE = https://libbsd.freedesktop.org/wiki/
COMMENT = BSD compatibility library.
LICENSE = 3-Clause BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk

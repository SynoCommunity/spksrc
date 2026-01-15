PKG_NAME = pkg-config
PKG_VERS = 0.29.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://pkgconfig.freedesktop.org/releases/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/glib

HOMEPAGE = https://www.freedesktop.org/wiki/Software/pkg-config/
COMMENT  = pkg-config is a helper tool used when compiling applications and libraries
LICENSE  = GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

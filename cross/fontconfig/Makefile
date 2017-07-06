PKG_NAME = fontconfig
PKG_VERS = 2.12.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.freedesktop.org/software/fontconfig/release
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/expat cross/freetype

HOMEPAGE = http://www.freedesktop.org/wiki/Software/fontconfig/
COMMENT  = Fontconfig is a library for configuring and customizing font access.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-docs --enable-iconv

include ../../mk/spksrc.cross-cc.mk


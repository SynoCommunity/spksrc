PKG_NAME = fontconfig
PKG_VERS = 2.14.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.freedesktop.org/software/fontconfig/release
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libexpat cross/freetype cross/libuuid

HOMEPAGE = https://www.freedesktop.org/wiki/Software/fontconfig/
COMMENT  = Fontconfig is a library for configuring and customizing font access.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-docs --enable-iconv

include ../../mk/spksrc.cross-cc.mk

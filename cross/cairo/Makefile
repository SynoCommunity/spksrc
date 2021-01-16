PKG_NAME = cairo
PKG_VERS = 1.16.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.cairographics.org/releases/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpng cross/freetype cross/pixman cross/fontconfig

HOMEPAGE = https://www.cairographics.org
COMMENT  = Cairo is a 2D graphics library with support for multiple output devices.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
ADDITIONAL_CPPFLAGS = -O


include ../../mk/spksrc.cross-cc.mk

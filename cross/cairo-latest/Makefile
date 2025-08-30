PKG_NAME = cairo
PKG_VERS = 1.18.4
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.cairographics.org/releases/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpng cross/freetype cross/pixman cross/fontconfig cross/glib

# ERROR: Could not get define '__FLOAT_WORD_ORDER__'
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

HOMEPAGE = https://www.cairographics.org
COMMENT  = Cairo is a 2D graphics library with support for multiple output devices.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = -Dtests=disabled
ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-meson.mk

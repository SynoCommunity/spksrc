PKG_NAME = cairo
PKG_VERS = 1.18.4
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.cairographics.org/releases/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpng cross/freetype cross/pixman cross/fontconfig cross/glib

# gcc only defines __FLOAT_WORD_ORDER__ from 4.8 on these toolchains; without it meson
# stops at "Could not get define '__FLOAT_WORD_ORDER__'". Stated as a floor rather than an
# arch list so a newer compiler lifts it, and so archs nobody tried are covered too:
# x86-5.2 and x64-5.2 (4.7.3) lack the define just as ppc853x (4.3.7) does.
MIN_GCC_VERSION = 4.8

HOMEPAGE = https://www.cairographics.org
COMMENT  = Cairo is a 2D graphics library with support for multiple output devices.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = -Dtests=disabled
ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-meson.mk

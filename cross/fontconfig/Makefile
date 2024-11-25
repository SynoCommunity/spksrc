PKG_NAME = fontconfig
PKG_VERS = 2.15.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.freedesktop.org/software/fontconfig/release
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libexpat cross/freetype cross/libuuid

HOMEPAGE = https://www.freedesktop.org/wiki/Software/fontconfig/
COMMENT  = Fontconfig is a library for configuring and customizing font access.
LICENSE  = GPLv2

CONFIGURE_ARGS  = -Ddoc=disabled
CONFIGURE_ARGS += -Dtests=disabled
CONFIGURE_ARGS += -Dcache-build=disabled

ADDITIONAL_CFLAGS  = -O
ADDITIONAL_CFLAGS += -std=c99

include ../../mk/spksrc.cross-meson.mk

PKG_NAME = fontconfig
PKG_VERS = 2.14.2
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

ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, $(TC_GCC), 4.8),1) 
ADDITIONAL_CFLAGS += -std=c99
else
ADDITIONAL_CFLAGS += -std=c11
endif

include ../../mk/spksrc.cross-meson.mk

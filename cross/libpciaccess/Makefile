PKG_NAME = libpciaccess
PKG_VERS = 0.19
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gitlab.freedesktop.org/xorg/lib/libpciaccess/-/archive/$(PKG_NAME)-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://gitlab.freedesktop.org/xorg/lib/libpciaccess
COMMENT  = Generic PCI access library.
LICENSE  = https://gitlab.freedesktop.org/xorg/lib/libpciaccess/-/blob/master/COPYING

ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.common.mk

# 0.19 uses a C99 for-loop init; pin gnu99 (gcc 4.x defaults to gnu89).
ifeq ($(call version_lt,$(TC_GCC),5),1)
CONFIGURE_ARGS += -Dc_std=gnu99
endif

include ../../mk/spksrc.cross-meson.mk

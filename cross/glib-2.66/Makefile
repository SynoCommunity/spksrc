PKG_NAME = glib
PKG_VERS = 2.66.8
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/glib/$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))

DEPENDS = cross/libffi cross/libiconv cross/pcre2 cross/zlib

HOMEPAGE = https://developer.gnome.org/glib/
COMMENT  = General-purpose utility library.
LICENSE  = LGPLv2.1+

# Only the 2008 PowerPC compiler (4.3.7) was ever excluded here; ARMv5's 4.6.4 builds it.
MIN_GCC_VERSION = 4.6

# https://docs.gtk.org/glib/building.html
CONFIGURE_ARGS += -Dlibmount=disabled
CONFIGURE_ARGS += -Ddefault_library=shared
CONFIGURE_ARGS += -Dselinux=disabled
CONFIGURE_ARGS += -Diconv=external

include ../../mk/spksrc.cross-meson.mk

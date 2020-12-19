PKG_NAME = glib
PKG_SHORT_VERS = 2.66
PKG_VERS = $(PKG_SHORT_VERS).3
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnome.org/pub/GNOME/sources/$(PKG_NAME)/$(PKG_SHORT_VERS)

DEPENDS = cross/libffi cross/pcre cross/zlib

HOMEPAGE = https://developer.gnome.org/glib/
COMMENT  = General-purpose utility library
LICENSE  = GPLv2

ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
CONFIGURE_ARGS += -Dc_args=-Wno-unused-value
endif

# https://developer.gnome.org/glib/stable/glib-building.html
CONFIGURE_ARGS += -Dman=false -Dlibmount=disabled -Ddefault_library=shared

include ../../mk/spksrc.cross-meson.mk

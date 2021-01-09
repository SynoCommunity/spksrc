PKG_NAME = glib
PKG_VERS = 2.66.4
PKG_SHORT_VERS = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnome.org/pub/GNOME/sources/$(PKG_NAME)/$(PKG_SHORT_VERS)

DEPENDS = cross/libffi cross/pcre cross/zlib

HOMEPAGE = https://developer.gnome.org/glib/
COMMENT  = General-purpose utility library
LICENSE  = GPLv2

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

# https://developer.gnome.org/glib/
# https://developer.gnome.org/glib/stable/glib-building.html
CONFIGURE_ARGS += -Dman=false -Dlibmount=disabled -Ddefault_library=shared -Dselinux=disabled

include ../../mk/spksrc.cross-meson.mk

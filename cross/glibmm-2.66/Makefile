PKG_NAME = glibmm
PKG_SHORT_VERS = 2.66
PKG_VERS = $(PKG_SHORT_VERS).5
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnome.org/pub/GNOME/sources/$(PKG_NAME)/$(PKG_SHORT_VERS)

DEPENDS = cross/libsigc++-2.12 cross/glib-2.66

HOMEPAGE = https://www.gtkmm.org/en/
COMMENT  = GLib is a low-level general-purpose library used mainly by GTK+/GNOME applications, but is useful for other programs as well. glibmm is the C++ wrapper for GLib.
LICENSE  = LGPLv2.1

CONFIGURE_ARGS += -Dbuild-documentation=false
CONFIGURE_ARGS += -Ddefault_library=shared

include ../../mk/spksrc.cross-meson.mk

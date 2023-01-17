PKG_NAME = glibmm
PKG_SHORT_VERS = 2.34
PKG_VERS = $(PKG_SHORT_VERS).1
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnome.org/pub/GNOME/sources/$(PKG_NAME)/$(PKG_SHORT_VERS)

DEPENDS = cross/libsigc++ cross/glib

HOMEPAGE = http://www.gtkmm.org/en/
COMMENT  =
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-documentation
CONFIGURE_ARGS += GLIB_COMPILE_SCHEMAS=$(WORK_DIR)/../../../native/glib/work-native/glib-*/gio/glib-compile-schemas

include ../../mk/spksrc.cross-cc.mk

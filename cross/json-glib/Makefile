PKG_NAME = json-glib
PKG_VERS = 1.6.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/GNOME/json-glib/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/glib

HOMEPAGE = https://gitlab.gnome.org/GNOME/json-glib 
COMMENT  = JSON-GLib implements a full JSON parser and generator using GLib and GObject, and integrates JSON with GLib data types.
LICENSE  = LGPLv2.1

CONFIGURE_ARGS  = -Dgtk_doc=disabled
CONFIGURE_ARGS += -Dman=false
CONFIGURE_ARGS += -Dtests=false

# let it find glib-mkenums
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-meson.mk

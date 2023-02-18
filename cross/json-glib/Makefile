PKG_NAME = json-glib
PKG_VERS = 1.6.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/GNOME/json-glib/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# To build using gitlab head (adjust git hash as needed)
#PKG_VERS = HEAD
#PKG_GIT_HASH = 5e6e76f6b91c85db158dfd960d769178b634a296
#PKG_DIST_SITE = https://gitlab.gnome.org/GNOME/json-glib/-/archive/HEAD
#PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS)-$(PKG_GIT_HASH).$(PKG_EXT)
#PKG_DIR = $(PKG_NAME)-$(PKG_VERS)-$(PKG_GIT_HASH)

# https://github.com/GNOME/json-glib/archive/refs/tags/1.6.6.tar.gz

DEPENDS = cross/glib

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://gitlab.gnome.org/GNOME/json-glib 
COMMENT  = JSON-GLib implements a full JSON parser and generator using GLib and GObject, and integrates JSON with GLib data types.
LICENSE  = LGPLv2.1

CONFIGURE_ARGS  = -Dgtk_doc=disabled
CONFIGURE_ARGS += -Dman=false
CONFIGURE_ARGS += -Dtests=false

# let it find glib-mkenums
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-meson.mk

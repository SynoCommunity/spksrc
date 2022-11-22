PKG_NAME = librsvg
PKG_VERS = 2.40.21
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/librsvg/$(word 1, $(subst ., ,$(PKG_VERS))).$(word 2, $(subst ., ,$(PKG_VERS)))
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/pango cross/libcroco cross/libxml2 cross/gdk-pixbuf

HOMEPAGE = https://wiki.gnome.org/Projects/LibRsvg
COMMENT  = A library to render SVG images to Cairo surfaces.
LICENSE  = LGPLv2.1

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --disable-pixbuf-loader
CONFIGURE_ARGS += --disable-introspection
ADDITIONAL_CFLAGS = -O

# let it find gdk-pixbuf-query-loaders
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-cc.mk

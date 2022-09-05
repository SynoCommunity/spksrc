PKG_NAME = gdk-pixbuf
PKG_VERS = 2.42.9
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/gdk-pixbuf/$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/glib cross/libpng cross/libjpeg cross/libtiff

HOMEPAGE = https://docs.gtk.org/gdk-pixbuf/
COMMENT  = gdk-pixbuf is an image loading library which is used by GTK.
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = -Dtests=false -Dinstalled_tests=false
CONFIGURE_ARGS += -Dman=false
CONFIGURE_ARGS += -Dgio_sniffing=false
ADDITIONAL_CFLAGS = -O

# let it find glib-compile-resources
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-meson.mk

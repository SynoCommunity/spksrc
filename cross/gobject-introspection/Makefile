PKG_NAME = gobject-introspection
PKG_VERS = 1.78.1
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gitlab.gnome.org/GNOME/$(PKG_NAME)/-/archive/$(PKG_VERS)

DEPENDS = cross/glib cross/libffi cross/cairo
BUILD_DEPENDS = cross/python311

HOMEPAGE = https://gi.readthedocs.io/
COMMENT  = GObject introspection is a middleware layer between C libraries (using GObject) and language bindings.
LICENSE  = LGPLv2+

# Dependency glib-2.0 needs: '>=2.78.0'
# Requires kernel >= 3.10 && gcc >= 7.5 to build successfully
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k evansport

#CONFIGURE_ARGS += -Dbuild_introspection_data=false

include ../../mk/spksrc.cross-meson.mk

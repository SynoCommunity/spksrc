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

# gobject-introspection requires glib-2.0 ≥ 2.78.0 (the current cross/glib-latest build is 2.78.4).
# cross/glib 2.78.4 in turn needs a Linux kernel ≥ 3.10, but the Evansport platform is limited to 3.2.101.
# As a result, Evansport is not supported.
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k evansport

CONFIGURE_ARGS += -Dbuild_introspection_data=false

include ../../mk/spksrc.cross-meson.mk

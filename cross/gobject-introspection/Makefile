PKG_NAME = gobject-introspection
PKG_VERS = 1.84.0
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/gobject-introspection/$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))

DEPENDS = cross/cairo cross/glib cross/libffi
BUILD_DEPENDS = native/python312

HOMEPAGE = https://gi.readthedocs.io/
COMMENT  = GObject introspection is a middleware layer between C libraries (using GObject) and language bindings.
LICENSE  = LGPLv2+

# let meson use libglib in install folder
ENV += LD_LIBRARY_PATH=$(STAGING_INSTALL_PREFIX)/lib

# disable 'Install g-ir-doc-tool and run related tests'
CONFIGURE_ARGS  = -Ddoctool=disabled
# disable 'Use cairo for tests'
CONFIGURE_ARGS += -Dcairo=disabled
# disable 'Build and run tests'
CONFIGURE_ARGS += -Dtests=false
# data creation fails when cross compiling (we don't have exe wrappers)
CONFIGURE_ARGS += -Dbuild_introspection_data=false

# 'Path or name of the Python interpreter to build for'
CONFIGURE_ARGS += -Dpython=$(WORK_DIR)/../../../native/python312/work-native/install/usr/local/bin/python3

include ../../mk/spksrc.cross-meson.mk

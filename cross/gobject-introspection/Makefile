PKG_NAME = gobject-introspection
PKG_VERS = 1.84.0
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/gobject-introspection/$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))

# Build is supported with prebuilt python312 only
DEPENDS = cross/glib cross/libffi cross/cairo
BUILD_DEPENDS = native/python312

HOMEPAGE = https://gi.readthedocs.io/
COMMENT  = GObject introspection is a middleware layer between C libraries (using GObject) and language bindings.
LICENSE  = LGPLv2+

# let meson use libglib in install folder
ENV += LD_LIBRARY_PATH=$(STAGING_INSTALL_PREFIX)/lib

# data creation fails when cross compiling (we don't have exe wrappers)
CONFIGURE_ARGS += -Dbuild_introspection_data=false

# 'Path or name of the Python interpreter to build for'
CONFIGURE_ARGS += -Dpython=$(WORK_DIR)/../../../native/$(PYTHON_PACKAGE)/work-native/install/usr/local/bin/python3
# pkg_config is mandatory to use the correct python header files
ENV += PKG_CONFIG_PATH=$(PYTHON_PACKAGE_WORK_DIR)/install/var/packages/$(PYTHON_PACKAGE)/target/lib/pkgconfig

include ../../mk/spksrc.cross-meson.mk

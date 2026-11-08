PKG_NAME = libgudev
PKG_VERS = 237
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/libgudev/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# libudev must match the udev the system runs: the virtual picks it (219 on DSM 7, 204 before).
# 237 is the last libgudev to take that old a libudev (>= 199); 238 needs libudev >= 251.
DEPENDS = cross/glib cross/libudev

HOMEPAGE = https://gitlab.gnome.org/GNOME/libgudev
COMMENT  = GObject bindings for libudev.
LICENSE  = LGPLv2.1

CONFIGURE_ARGS  = -Dtests=disabled
CONFIGURE_ARGS += -Dintrospection=disabled
CONFIGURE_ARGS += -Dvapi=disabled
CONFIGURE_ARGS += -Dgtk_doc=false

# let it find glib-mkenums
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-meson.mk

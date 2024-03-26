PKG_NAME = libcroco
PKG_VERS = 0.6.13
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/libcroco/$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/glib cross/libxml2

# REMARKS: Archived project! Repository and other project resources are read-only.
HOMEPAGE = https://gitlab.gnome.org/Archive/libcroco
COMMENT  = Cascading Style Sheet (CSS) parsing and manipulation toolkit.
LICENSE  = LGPL 2.1

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk

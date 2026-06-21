PKG_NAME = dbus
PKG_VERS = 1.13.22
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://dbus.freedesktop.org/releases/dbus
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libexpat

HOMEPAGE = https://www.freedesktop.org/wiki/Software/dbus/
COMMENT = D-Bus is a message bus system, a simple way for applications to talk to one another.
LICENSE = Academic Free License v2.1 or GPLv2

CMAKE_ARGS += -DDBUS_BUILD_TESTS=OFF
CMAKE_ARGS += -DDBUS_ENABLE_XML_DOCS=OFF
# EXPAT is located by find_package(EXPAT) via CMAKE_FIND_ROOT_PATH: the local
# staging (cross/libexpat) for a standalone build, or the python meta staging
# when shared - no explicit -DEXPAT_* path needed.

include ../../mk/spksrc.cross-cmake.mk

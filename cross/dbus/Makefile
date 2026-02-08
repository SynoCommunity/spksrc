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

ifneq ($(strip $(PYTHON_PACKAGE)),)
CMAKE_ARGS += -DEXPAT_INCLUDE_DIR=$(PYTHON_STAGING_INSTALL_PREFIX)/include
CMAKE_ARGS += -DEXPAT_LIBRARY=$(PYTHON_STAGING_INSTALL_PREFIX)/lib/libexpat.so
endif

include ../../mk/spksrc.cross-cmake.mk

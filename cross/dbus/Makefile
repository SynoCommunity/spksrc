PKG_NAME = dbus
PKG_VERS = 1.14.10
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://dbus.freedesktop.org/releases/dbus
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libexpat

HOMEPAGE = https://www.freedesktop.org/wiki/Software/dbus/
COMMENT = D-Bus is a message bus system, a simple way for applications to talk to one another.
LICENSE = Academic Free License v2.1 or GPLv2

# 1.14 refuses to autodetect this when cross-compiling and stops with a FATAL_ERROR.
CONFIGURE_ARGS += -DDBUS_SESSION_SOCKET_DIR=/tmp
CONFIGURE_ARGS += -DDBUS_BUILD_TESTS=OFF
CONFIGURE_ARGS += -DDBUS_ENABLE_XML_DOCS=OFF

include ../../mk/spksrc.cross-cmake.mk

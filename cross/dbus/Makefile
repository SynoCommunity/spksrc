PKG_NAME = dbus
PKG_VERS = 1.12.22
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/freedesktop/dbus/archive/refs/tags
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libexpat

HOMEPAGE = https://www.freedesktop.org/wiki/Software/dbus/
COMMENT  = D-Bus is a message bus system, a simple way for applications to talk to one another.
LICENSE  = GPLv2

CMAKE_DIR = $(WORK_DIR)/$(PKG_DIR)/cmake

CMAKE_ARGS += -DDBUS_BUILD_TESTS=OFF
CMAKE_ARGS += -DDBUS_ENABLE_XML_DOCS=OFF

include ../../mk/spksrc.cross-cmake.mk

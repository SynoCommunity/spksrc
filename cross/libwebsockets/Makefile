PKG_NAME = libwebsockets
PKG_VERS = 2.4.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/warmcat/libwebsockets/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

HOMEPAGE = http://libevent.org/
COMMENT  = An event notification library
LICENSE  = http://libevent.org/LICENSE.txt

include ../../mk/spksrc.cross-cmake.mk

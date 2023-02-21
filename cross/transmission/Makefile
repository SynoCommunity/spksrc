PKG_NAME = transmission
PKG_VERS = 4.0.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/transmission/transmission/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl cross/curl cross/libevent

HOMEPAGE = https://transmissionbt.com
COMMENT  = A Fast, Easy, and Free BitTorrent Client
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1

CMAKE_ARGS  = -DCMAKE_BUILD_TYPE=RelWithDebInfo ..

include ../../mk/spksrc.cross-cmake.mk

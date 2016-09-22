PKG_NAME = transmission
PKG_VERS = 2.92
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/transmission/transmission-releases/raw/master
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl cross/curl cross/libevent

HOMEPAGE = http://www.transmissionbt.com
COMMENT  = A Fast, Easy, and Free BitTorrent Client
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = HAVE_CXX=yes --disable-nls --enable-daemon --enable-utp

include ../../mk/spksrc.cross-cc.mk

PKG_NAME = ympd
PKG_VERS = 1.3.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/notandy/ympd/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libmpdclient cross/openssl

HOMEPAGE = https://ympd.org/
COMMENT  = Standalone MPD Web GUI written in C, utilizing Websockets and Bootstrap/JS.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cmake.mk

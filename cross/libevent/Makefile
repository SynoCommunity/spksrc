PKG_NAME = libevent
PKG_VERS = 2.0.19-stable
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://cloud.github.com/downloads/libevent/libevent
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

HOMEPAGE = http://monkey.org/~provos/libevent/
COMMENT  = An event notification library
LICENSE  = http://monkey.org/~provos/libevent/LICENSE

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk


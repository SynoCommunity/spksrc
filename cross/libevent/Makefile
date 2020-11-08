PKG_NAME = libevent
PKG_VERS_MAJOR = 2.1
PKG_VERS_MINOR = 12-stable
PKG_VERS = $(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libevent/libevent/releases/download/release-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR)

DEPENDS = cross/openssl

HOMEPAGE = https://libevent.org
COMMENT  = Event notification library
LICENSE  = 3-clause BSD

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

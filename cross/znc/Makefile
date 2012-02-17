PKG_NAME = znc
PKG_VERS = 0.204
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://znc.in/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/c-ares

HOMEPAGE = http://wiki.znc.in/
COMMENT  = Advanced IRC bouncer
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-extra

include ../../mk/spksrc.cross-cc.mk


PKG_NAME = socat
PKG_VERS = 1.7.3.2
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.dest-unreach.org/socat/download

DEPENDS = cross/openssl

HOMEPAGE = http://www.dest-unreach.org/socat/
COMMENT  = socat: multipurpose relay
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-fips

include ../../mk/spksrc.cross-cc.mk

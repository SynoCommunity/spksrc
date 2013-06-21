PKG_NAME = iodine
PKG_VERS = 0.6.0-rc1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://code.kryo.se/iodine/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = http://code.kryo.se/iodine/
COMMENT  = tunneling IPv4 data through a DNS server 
LICENSE  = MIT

GNU_CONFIGURE = 0
CONFIGURE_TARGET=config

include ../../mk/spksrc.cross-cc.mk

.PHONY: config
config:

PKG_NAME = aria2
PKG_VERS = 1.31.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/$(PKG_NAME)/$(PKG_NAME)/releases/download/release-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/c-ares cross/expat cross/nettle cross/openssl cross/zlib

HOMEPAGE = http://aria2.github.io
COMMENT  = aria2 is a lightweight multi-protocol and multi-source command-line download utility.
LICENSE  = GPLv2/GPLv3

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

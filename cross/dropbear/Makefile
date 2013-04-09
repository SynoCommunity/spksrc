PKG_NAME = dropbear
PKG_VERS = 2013.56
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://matt.ucc.asn.au/dropbear/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = https://matt.ucc.asn.au/dropbear/dropbear.html
COMMENT  = Dropbear is a relatively small SSH server and client.
LICENSE  = MIT

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

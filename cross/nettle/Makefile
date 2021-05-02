PKG_NAME = nettle
PKG_VERS = 3.7.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gmp

HOMEPAGE = https://www.lysator.liu.se/~nisse/nettle/
COMMENT  = Nettle is a cryptographic library that is designed to fit easily in more or less any context.
LICENSE  = LGPLv3

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

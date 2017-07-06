PKG_NAME = nettle
PKG_VERS = 3.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/nettle
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gmp

HOMEPAGE = http://www.lysator.liu.se/~nisse/nettle/
COMMENT  = Nettle is a cryptographic library that is designed to fit easily in more or less any context
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-shared
ifeq ($(findstring $(ARCH),88f5281 88f6281),$(ARCH))
CONFIGURE_ARGS += --disable-assembler
endif

include ../../mk/spksrc.cross-cc.mk


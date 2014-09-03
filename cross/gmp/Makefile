PKG_NAME = gmp
PKG_VERS_SHORT = 6.0.0
PKG_VERS = $(PKG_VERS_SHORT)a
PKG_EXT = tar.lz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gmplib.org/download/gmp
PKG_DIR = $(PKG_NAME)-$(PKG_VERS_SHORT)

DEPENDS =

HOMEPAGE = http://gmplib.org/
COMMENT  = GMP is a free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers
LICENSE  = LGPL

GNU_CONFIGURE = 1
ifeq ($(findstring $(ARCH),88f5281 88f6281),$(ARCH))
CONFIGURE_ARGS = --disable-assembly
endif

include ../../mk/spksrc.cross-cc.mk


PKG_NAME = gmp
PKG_VERS = 6.1.1
PKG_EXT = tar.lz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gmplib.org/download/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://gmplib.org/
COMMENT  = GMP is a free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers
LICENSE  = LGPL

GNU_CONFIGURE = 1
ifeq ($(findstring $(ARCH),88f5281 88f6281),$(ARCH))
CONFIGURE_ARGS = --disable-assembly
endif

include ../../mk/spksrc.cross-cc.mk


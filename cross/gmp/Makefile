PKG_NAME = gmp
PKG_VERS = 6.1.2
PKG_EXT = tar.lz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gmplib.org/download/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://gmplib.org/
COMMENT  = GMP is a free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers
LICENSE  = LGPL

include ../../mk/spksrc.cross-cc.mk

GNU_CONFIGURE = 1
ifeq ($(findstring $(ARCH), $(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --disable-assembly
endif

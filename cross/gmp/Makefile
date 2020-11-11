PKG_NAME = gmp
PKG_VERS = 6.2.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://gmplib.org/
COMMENT  = GMP is a free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers.
LICENSE  = LGPLv3 or GPLv2

GNU_CONFIGURE = 1


# create c++ library of gmp. This is required by cross/rnm
CONFIGURE_ARGS += --enable-cxx

include ../../mk/spksrc.cross-cc.mk

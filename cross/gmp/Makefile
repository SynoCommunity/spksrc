PKG_NAME = gmp
PKG_VERS = 6.2.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/gmp
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://gmplib.org/
COMMENT  = GMP is a free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers.
LICENSE  = LGPLv3 or GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-static

# create c++ library of gmp. This is required by cross/rnm
CONFIGURE_ARGS += --enable-cxx

include ../../mk/spksrc.cross-cc.mk

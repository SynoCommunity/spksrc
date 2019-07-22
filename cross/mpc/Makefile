PKG_NAME = mpc
PKG_VERS = 1.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/mpc
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gmp cross/mpfr

HOMEPAGE = http://www.multiprecision.org/mpc/home.html
COMMENT  = C library for the arithmetic of complex numbers with arbitrarily high precision and correct rounding of the result.
LICENSE  = GNU Lesser GPL v3

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --with-gmp=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-mpfr=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

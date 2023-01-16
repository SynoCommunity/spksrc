PKG_NAME = mpfr
PKG_VERS = 4.0.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/mpfr
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gmp

HOMEPAGE = https://www.mpfr.org/
COMMENT  = C library for multiple-precision floating-point computations with correct rounding.
LICENSE  = GNU Lesser GPL

# Cumulative patches from https://www.mpfr.org/mpfr-4.0.2/allpatches
# for version 4.0.2-p1

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --with-gmp=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --disable-static

COMPILE_MAKE_OPTIONS += SUBDIRS=src
INSTALL_MAKE_OPTIONS = install SUBDIRS=src DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

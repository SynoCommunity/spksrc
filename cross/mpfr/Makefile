PKG_NAME = mpfr
PKG_VERS = 4.0.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.mpfr.org/mpfr-current
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gmp

HOMEPAGE = https://www.mpfr.org/
COMMENT  = C library for multiple-precision floating-point computations with correct rounding.
LICENSE  = GNU Lesser GPL

# Cumulative patches from https://www.mpfr.org/mpfr-4.0.1/allpatches

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --with-gmp=$(STAGING_INSTALL_PREFIX)

COMPILE_TARGET = mpfr_compile
INSTALL_TARGET = mpfr_install

include ../../mk/spksrc.cross-cc.mk

# Do not build test nor doc
.PHONY: mpfr_compile mpfr_install

mpfr_compile:
	@$(RUN) $(MAKE) SUBDIRS=src

mpfr_install:
	$(RUN) $(MAKE) SUBDIRS=src DESTDIR=$(INSTALL_DIR) install prefix=$(INSTALL_PREFIX)

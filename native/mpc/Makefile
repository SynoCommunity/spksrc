PKG_NAME = mpc
PKG_VERS = 1.0.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://multiprecision.org/mpc/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = native/gmp native/mpfr

HOMEPAGE = http://multiprecision.org
COMMENT  = C library for the arithmetic of complex numbers with arbitrarily high precision and correct rounding
LICENSE  = LGPL

HOST_ARCH = $(shell getconf LONG_BIT)
ifeq ($(HOST_ARCH),64)
LIBDIR=lib64
else
LIBDIR=lib
endif


GNU_CONFIGURE = 1

CONFIGURE_ARGS = --with-gmp=$(WORK_DIR)/../../gmp/work-native/install/usr/local
CONFIGURE_ARGS += --with-mpfr-include=$(WORK_DIR)/../../mpfr/work-native/install/usr/local/include
CONFIGURE_ARGS += --with-mpfr-lib=$(WORK_DIR)/../../mpfr/work-native/install/usr/local/$(LIBDIR)


include ../../mk/spksrc.native-cc.mk

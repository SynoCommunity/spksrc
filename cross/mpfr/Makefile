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

include ../../mk/spksrc.cross-cc.mk

# Replace libgmp.la location in  install/var/packages/homeassistant/target/lib/libmpfr.la
# /spksrc/spk/homeassistant/work-x64-6.1/install/var/packages/homeassistant/target/lib/libgmp.la
# LT_SYS_LIBRARY_PATH does not help


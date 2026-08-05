PKG_NAME = mpc
PKG_VERS = 1.0.3
PKG_EXT  = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/mpc
PKG_DIR  = $(PKG_NAME)-$(PKG_VERS)

# gmp+mpfr via NATIVE_DEPENDS into this prefix -> --with-* = $(STAGING_INSTALL_PREFIX)
NATIVE_DEPENDS = native/gmp native/mpfr

HOMEPAGE = http://www.multiprecision.org/
COMMENT  = GNU MPC (host), the version bundled with gcc-8.5; built for native/gcc8.
LICENSE  = LGPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-static --disable-shared
CONFIGURE_ARGS += --with-gmp=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-mpfr=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.native-cc.mk

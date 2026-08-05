PKG_NAME = mpfr
PKG_VERS = 3.1.4
PKG_EXT  = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/mpfr
PKG_DIR  = $(PKG_NAME)-$(PKG_VERS)

# NATIVE_DEPENDS installs gmp into THIS package's own prefix, so --with-gmp is
# just $(STAGING_INSTALL_PREFIX) (no absolute cross-package path). This also
# works when mpfr is itself pulled via NATIVE_DEPENDS by native/gcc8: the prefix
# is then gcc8's, where gmp was already installed.
NATIVE_DEPENDS = native/gmp

HOMEPAGE = https://www.mpfr.org/
COMMENT  = GNU MPFR (host), the version bundled with gcc-8.5; built for native/gcc8.
LICENSE  = LGPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-static --disable-shared
CONFIGURE_ARGS += --with-gmp=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.native-cc.mk

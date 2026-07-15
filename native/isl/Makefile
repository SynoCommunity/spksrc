PKG_NAME = isl
PKG_VERS = 0.18
PKG_EXT  = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gcc.gnu.org/pub/gcc/infrastructure
PKG_DIR  = $(PKG_NAME)-$(PKG_VERS)

# gmp via NATIVE_DEPENDS into this prefix -> --with-gmp-prefix = $(STAGING_INSTALL_PREFIX)
NATIVE_DEPENDS = native/gmp

HOMEPAGE = https://libisl.sourceforge.io/
COMMENT  = Integer Set Library (host), the version bundled with gcc-8.5; built for native/gcc8.
LICENSE  = MIT

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-static --disable-shared
CONFIGURE_ARGS += --with-gmp-prefix=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.native-cc.mk

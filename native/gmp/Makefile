PKG_NAME = gmp
PKG_VERS = 6.1.0
PKG_EXT  = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/gmp
PKG_DIR  = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://gmplib.org/
COMMENT  = GNU MP (host), the version bundled with gcc-8.5; built for native/gcc8.
LICENSE  = LGPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-static --disable-shared

include ../../mk/spksrc.native-cc.mk

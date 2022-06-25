PKG_NAME = plzip
PKG_VERS = 1.10
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.savannah.gnu.org/releases/lzip/plzip
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/lzlib

HOMEPAGE = http://lzip.nongnu.org/plzip.html
COMMENT  = Plzip is a massively parallel (multi-threaded) implementation of lzip, fully compatible with lzip 1.4 or newer.
LICENSE  = GPLv2

# configure does not support GNU_CONFIGURE (--host, --build)
# workaround inspired by: https://stackoverflow.com/questions/53885273/cross-compile-zlib-for-arm
CONFIGURE_ARGS  = CXX=$(TC_PATH)$(TC_PREFIX)g++
CONFIGURE_ARGS += AR=$(TC_PATH)$(TC_PREFIX)ar
CONFIGURE_ARGS += RANTLIB=$(TC_PATH)$(TC_PREFIX)ranlib

CONFIGURE_ARGS += CPPFLAGS="-I $(STAGING_INSTALL_PREFIX)/include"
CONFIGURE_ARGS += LDFLAGS="-L $(STAGING_INSTALL_PREFIX)/lib"

include ../../mk/spksrc.cross-cc.mk

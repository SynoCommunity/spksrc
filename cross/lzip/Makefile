PKG_NAME = lzip
PKG_VERS = 1.23
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.savannah.gnu.org/releases/lzip
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://lzip.nongnu.org/plzip.html
COMMENT  = Lzip is a lossless data compressor with a user interface similar to the one of gzip or bzip2. Lzip uses a simplified form of the 'Lempel-Ziv-Markov chain-Algorithm' (LZMA) stream format, chosen to maximize safety and interoperability.
LICENSE  = GPLv2

# configure does not support GNU_CONFIGURE (--host, --build)
# workaround inspired by: https://stackoverflow.com/questions/53885273/cross-compile-zlib-for-arm
CONFIGURE_ARGS  = CXX=$(TC_PATH)$(TC_PREFIX)g++
CONFIGURE_ARGS += AR=$(TC_PATH)$(TC_PREFIX)ar
CONFIGURE_ARGS += RANTLIB=$(TC_PATH)$(TC_PREFIX)ranlib

include ../../mk/spksrc.cross-cc.mk

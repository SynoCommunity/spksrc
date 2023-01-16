PKG_NAME = lzlib
PKG_VERS = 1.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.savannah.gnu.org/releases/lzip/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.nongnu.org/lzip/lzlib.html
COMMENT  = Lzlib is a data compression library providing in-memory LZMA compression and decompression functions, including integrity checking of the decompressed data. The compressed data format used by the library is the lzip format. Lzlib is written in C. 
LICENSE  = GPLv2

CONFIGURE_ARGS = CC=$(TC_PATH)$(TC_PREFIX)gcc

include ../../mk/spksrc.cross-cc.mk

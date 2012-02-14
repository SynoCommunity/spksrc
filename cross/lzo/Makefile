PKG_NAME = lzo
PKG_VERS = 2.06
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.oberhumer.com/opensource/lzo/download/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.oberhumer.com/opensource/lzo/
COMMENT  = LZO is a data compression library which is suitable for data de-/compression in real-time.
LICENSE  = GPL v2+

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-shared

include ../../mk/spksrc.cross-cc.mk


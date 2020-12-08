PKG_NAME = lzo
PKG_VERS = 2.10
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.oberhumer.com/opensource/lzo/download/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.oberhumer.com/opensource/lzo/
COMMENT  = LZO is a data compression library which is suitable for data de-/compression in real-time.
LICENSE  = GPLv2+

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-shared --disable-static

include ../../mk/spksrc.cross-cc.mk

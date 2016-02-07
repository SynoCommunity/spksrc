PKG_NAME = opus
PKG_VERS = 1.1.1
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.xiph.org/releases/$(PKG_NAME)

DEPENDS =

HOMEPAGE = http://www.opus-codec.org/
COMMENT  = Totally open, royalty-free, highly versatile audio codec
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk


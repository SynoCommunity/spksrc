PKG_NAME_MAIN = opus
PKG_NAME = lib$(PKG_NAME_MAIN)
PKG_VERS = 1.1.1
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME_MAIN)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME_MAIN)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.xiph.org/releases/$(PKG_NAME_MAIN)

DEPENDS =

HOMEPAGE = http://www.opus-codec.org/
COMMENT  = Totally open, royalty-free, highly versatile audio codec
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk


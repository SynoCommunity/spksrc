PKG_NAME_MAIN = mpg123
PKG_NAME = lib$(PKG_NAME_MAIN)
PKG_VERS = 1.22.4
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME_MAIN)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME_MAIN)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/$(PKG_NAME_MAIN)/files/$(PKG_NAME_MAIN)/$(PKG_VERS)

DEPENDS = cross/alsa-lib

HOMEPAGE = http://www.mpg123.de
COMMENT  = Fast console MPEG Audio Player and decoder library (mp3 alternative)
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk


PKG_NAME = libmpdclient
PKG_VERS_MAIN = 2
PKG_VERS = $(PKG_VERS_MAIN).10
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://www.musicpd.org/download/$(PKG_NAME)/$(PKG_VERS_MAIN)

DEPENDS = 

HOMEPAGE = http://www.musicpd.org
COMMENT  = MPD client
LICENSE  = 

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --disable-documentation

include ../../mk/spksrc.cross-cc.mk


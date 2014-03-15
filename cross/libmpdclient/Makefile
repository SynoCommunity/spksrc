PKG_NAME = libmpdclient
PKG_SHORT_VERS = 2
PKG_VERS = $(PKG_SHORT_VERS).9
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.musicpd.org/download/$(PKG_NAME)/$(PKG_SHORT_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  =

HOMEPAGE = http://www.musicpd.org
COMMENT  = Asynchronous API library for interfacing MPD in the C, C++ & Objective C languages
LICENSE  = BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-documentation

include ../../mk/spksrc.cross-cc.mk


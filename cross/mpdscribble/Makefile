PKG_NAME = mpdscribble
PKG_VERS = 0.22
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.musicpd.org/download/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/curl cross/glib cross/libmpdclient

HOMEPAGE = http://www.musicpd.org/
COMMENT  = An audioscrobbler for the Music Player Daemon.
LICENSE  = GPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

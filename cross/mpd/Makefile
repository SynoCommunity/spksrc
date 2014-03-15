PKG_NAME = mpd
PKG_SHORT_VERS = 0.17
PKG_VERS = $(PKG_SHORT_VERS).6
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.musicpd.org/download/$(PKG_NAME)/$(PKG_SHORT_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/audiofile cross/curl cross/faad2 cross/flac cross/glib
DEPENDS += cross/libid3tag cross/libmad cross/libogg cross/lame
DEPENDS += cross/libsamplerate cross/libvorbis cross/sqlite

HOMEPAGE = http://mpd.wikia.com/wiki/Music_Player_Daemon_Wiki
COMMENT  = Flexible, powerful, server-side application for playing music
LICENSE  = GPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk


PKG_NAME = mpd
PKG_VERS = 0.16.6
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/musicpd/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/glib cross/alsa-lib cross/libmad cross/libogg cross/flac
DEPENDS += cross/audiofile cross/libid3tag cross/libvorbis cross/lame

MAINTAINER = packages@packages.nas-forum.com
HOMEPAGE   = http://mpd.wikia.com/wiki/Music_Player_Daemon_Wiki
COMMENT    = Flexible, powerful, server-side application for playing music
LICENSE    =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = 

INSTALL_PREFIX  = /usr/local/$(PKG_NAME)

include ../../mk/spksrc.cross-cc.mk


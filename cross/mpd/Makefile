PKG_NAME = mpd
PKG_VERS = 0.16.7
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/MusicPlayerDaemon/MPD/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = MPD-$(PKG_VERS)

DEPENDS  = cross/glib cross/alsa-lib cross/libmad cross/libogg cross/flac
DEPENDS += cross/audiofile cross/libid3tag cross/libvorbis cross/lame

HOMEPAGE = http://mpd.wikia.com/wiki/Music_Player_Daemon_Wiki
COMMENT  = Flexible, powerful, server-side application for playing music
LICENSE  = GPL-2.0

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = mpd_pre_configure


include ../../mk/spksrc.cross-cc.mk

.PHONY: mpd_pre_configure
mpd_pre_configure:
	$(RUN) ./autogen.sh

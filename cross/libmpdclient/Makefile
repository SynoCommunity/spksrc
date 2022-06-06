PKG_NAME = libmpdclient
PKG_VERS = 2.20
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/MusicPlayerDaemon/libmpdclient/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# https://github.com/MusicPlayerDaemon/libmpdclient/archive/refs/tags/v2.20.tar.gz

DEPENDS =

HOMEPAGE = https://www.musicpd.org/libs/libmpdclient/
COMMENT  = libmpdclient is a C library which implements the Music Player Daemon protocol.
LICENSE  = 3-Clause BSD

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-meson.mk

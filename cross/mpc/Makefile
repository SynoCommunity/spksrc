PKG_NAME = mpc
PKG_VERS = 0.35
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/MusicPlayerDaemon/mpc/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libmpdclient

HOMEPAGE = https://www.musicpd.org/clients/mpc/
COMMENT  = Command-line client for MPD
LICENSE  = GPLv2

CONFIGURE_ARGS = -Diconv=disabled

include ../../mk/spksrc.cross-meson.mk

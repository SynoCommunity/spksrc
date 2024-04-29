PKG_NAME = irssi
PKG_VERS = 1.4.4
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/irssi-import/irssi/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/glib cross/ncursesw cross/openssl

HOMEPAGE = http://www.irssi.org/
COMMENT  = Irssi is a terminal based IRC client for UNIX systems. It also supports SILC and ICB protocols via plugins.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --without-perl

include ../../mk/spksrc.cross-cc.mk

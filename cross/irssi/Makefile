PKG_NAME = irssi
PKG_VERS = 0.8.17
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/irssi-import/$(PKG_NAME)/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/glib cross/ncurses cross/openssl

HOMEPAGE = http://www.irssi.org/
COMMENT  = Irssi is a terminal based IRC client for UNIX systems. It also supports SILC and ICB protocols via plugins.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-ssl=openssl --with-curses=ncurses --without-perl

INSTALL_TARGET = myInstall
POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)

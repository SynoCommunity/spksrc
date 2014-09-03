PKG_NAME = tmux
PKG_VERS = 1.9a
PKG_VERS_CUT = 1.9a
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/$(PKG_NAME)/files/$(PKG_NAME)/$(PKG_NAME)-1.9
PKG_DIR = $(PKG_NAME)-$(PKG_VERS_CUT)

DEPENDS = cross/ncurses cross/libevent

HOMEPAGE = http://sourceforge.net/projects/tmux/
COMMENT  = tmux is a terminal multiplexer, it enables a number of terminals or windows to be accessed and controlled from a single terminal. tmux is intended to be a simple, modern, BSD-licensed alternative to programs such as GNU screen.
LICENSE  = BSD License

GNU_CONFIGURE = 1

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)

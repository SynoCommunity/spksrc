PKG_NAME = tmux
PKG_VERS = 3.1c
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/$(PKG_NAME)/$(PKG_NAME)/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses cross/libevent

HOMEPAGE = https://github.com/tmux/tmux/wiki
COMMENT  = tmux is a terminal multiplexer, it enables a number of terminals or windows to be accessed and controlled from a single terminal. tmux is intended to be a simple, modern, BSD-licensed alternative to programs such as GNU screen.
LICENSE  = BSD License

GNU_CONFIGURE = 1

INSTALL_TARGET = tmux_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: tmux_install
tmux_install:
	@$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/orig
	mv $(STAGING_INSTALL_PREFIX)/bin/tmux $(STAGING_INSTALL_PREFIX)/orig/tmux
	install -m 755 src/tmux-utf8 $(STAGING_INSTALL_PREFIX)/bin/tmux

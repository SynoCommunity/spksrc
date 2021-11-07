PKG_NAME = tmux
PKG_VERS = 3.2a
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/tmux/$(PKG_NAME)/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses cross/libevent

HOMEPAGE = https://github.com/tmux/tmux/wiki
COMMENT  = tmux is a terminal multiplexer, it enables a number of terminals or windows to be accessed and controlled from a single terminal. tmux is intended to be a simple, modern, BSD-licensed alternative to programs such as GNU screen.
LICENSE  = BSD License

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = tmux_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: tmux_pre_configure
tmux_pre_configure:
	@$(MSG) Reconfigure with patched configure.ac
	@$(RUN) autoreconf

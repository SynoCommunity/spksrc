PKG_NAME = byobu
PKG_VERS = 7.23
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/dustinkirkland/byobu/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://byobu.org/
COMMENT = Byobu is a GPLv3 open source text-based window manager and terminal multiplexer. It was originally designed to provide elegant enhancements to the otherwise functional, plain, practical GNU Screen, for the Ubuntu server distribution. Byobu now includes an enhanced profiles, convenient keybindings, configuration utilities, and toggle-able system status notifications for both the GNU Screen window manager and the more modern Tmux terminal multiplexer, and works on most Linux, BSD, and Mac distributions.
LICENSE = GPLv3

PRE_CONFIGURE_TARGET = byobu_pre_configure

GNU_CONFIGURE = 1
CONFIGURE_ARGS += --disable-trustmux

include ../../mk/spksrc.cross-cc.mk

.PHONY: byobu_pre_configure
byobu_pre_configure:
	@$(RUN) ./autogen.sh

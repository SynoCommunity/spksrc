PKG_NAME = byobu
PKG_VERS = 5.133
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).orig.$(PKG_EXT)
PKG_DIST_SITE = https://launchpad.net/byobu/trunk/$(PKG_VERS)/+download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://byobu.org/
COMMENT = Byobu is a GPLv3 open source text-based window manager and terminal multiplexer. It was originally designed to provide elegant enhancements to the otherwise functional, plain, practical GNU Screen, for the Ubuntu server distribution. Byobu now includes an enhanced profiles, convenient keybindings, configuration utilities, and toggle-able system status notifications for both the GNU Screen window manager and the more modern Tmux terminal multiplexer, and works on most Linux, BSD, and Mac distributions.
LICENSE = GPLv3

PRE_COMPILE_TARGET = byobu_pre_compile

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: byobu_pre_compile
byobu_pre_compile:
	@$(RUN) ; ./autogen.sh

PKG_NAME      = byobu
PKG_VERS      = 6.13
PKG_EXT       = zip
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/dustinkirkland/byobu/archive/refs/tags
PKG_DIR       = $(PKG_NAME)-$(PKG_VERS)
HOMEPAGE      = https://byobu.org/
COMMENT       = Byobu is a GPLv3 open source text-based window manager and terminal multiplexer. It was originally designed to provide elegant enhancements to the otherwise functional, plain, practical GNU Screen, for the Ubuntu server distribution. Byobu now includes an enhanced profiles, convenient keybindings, configuration utilities, and toggle-able system status notifications for both the GNU Screen window manager and the more modern Tmux terminal multiplexer, and works on most Linux, BSD, and Mac distributions.
LICENSE       = GPLv3

DEPENDS = cross/tmux cross/screen5

include ../../mk/spksrc.common.mk

POST_EXTRACT_TARGET = byobu_post_extract

byobu_post_extract:
	cd $(WORK_DIR)/$(PKG_DIR) && ./autogen.sh

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk


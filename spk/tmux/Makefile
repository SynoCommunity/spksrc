SPK_NAME = tmux
SPK_VERS = 2.1
SPK_REV = 2
SPK_ICON = src/tmux.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = tmux is a terminal multiplexer, it enables a number of terminals or windows to be accessed and controlled from a single terminal. tmux is intended to be a simple, modern, BSD-licensed alternative to programs such as GNU screen.
RELOAD_UI = no
DISPLAY_NAME = Tmux
STARTABLE = no
BETA = 1
CHANGELOG = Update to 2.1

HOMEPAGE   = http://tmux.github.io
LICENSE    = BSD License

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = tmux_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: tmux_extra_install
tmux_extra_install:
	install -m 755 src/tmux-utf8 $(STAGING_DIR)/bin/tmux-utf8

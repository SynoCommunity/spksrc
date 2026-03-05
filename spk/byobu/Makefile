SPK_NAME = byobu
SPK_VERS = 5.133
SPK_REV = 1
SPK_ICON = src/byobu.png

PYTHON_PACKAGE = python312
SPK_DEPENDS = "$(PYTHON_PACKAGE):synocli-net"

# Python 3.12 not supported
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

DEPENDS = cross/byobu
DEPENDS += cross/newt

MAINTAINER = tofuHero
DESCRIPTION = Byobu is a GPLv3 open source text-based window manager and terminal multiplexer. It was originally designed to provide elegant enhancements to the otherwise functional, plain, practical GNU Screen, for the Ubuntu server distribution. Byobu now includes an enhanced profiles, convenient keybindings, configuration utilities, and toggle-able system status notifications for both the GNU Screen window manager and the more modern Tmux terminal multiplexer, and works on most Linux, BSD, and Mac distributions.
DISPLAY_NAME = byobu
STARTABLE = no
CHANGELOG = "Initial package release."

LICENSE  = GPLv3
HOMEPAGE = https://www.byobu.org/

SPK_COMMANDS  = bin/byobu
SPK_COMMANDS += bin/byobu-config
SPK_COMMANDS += bin/byobu-ctrl-a
SPK_COMMANDS += bin/byobu-disable
SPK_COMMANDS += bin/byobu-disable-prompt
SPK_COMMANDS += bin/byobu-enable
SPK_COMMANDS += bin/byobu-enable-prompt
SPK_COMMANDS += bin/byobu-export
SPK_COMMANDS += bin/byobu-janitor
SPK_COMMANDS += bin/byobu-launch
SPK_COMMANDS += bin/byobu-launcher
SPK_COMMANDS += bin/byobu-launcher-install
SPK_COMMANDS += bin/byobu-launcher-uninstall
SPK_COMMANDS += bin/byobu-layout
SPK_COMMANDS += bin/byobu-prompt
SPK_COMMANDS += bin/byobu-quiet
SPK_COMMANDS += bin/byobu-reconnect-sockets
SPK_COMMANDS += bin/byobu-screen
SPK_COMMANDS += bin/byobu-select-backend
SPK_COMMANDS += bin/byobu-select-profile
SPK_COMMANDS += bin/byobu-select-session
SPK_COMMANDS += bin/byobu-shell
SPK_COMMANDS += bin/byobu-silent
SPK_COMMANDS += bin/byobu-status
SPK_COMMANDS += bin/byobu-status-detail
SPK_COMMANDS += bin/byobu-tmux
SPK_COMMANDS += bin/byobu-ugraph
SPK_COMMANDS += bin/byobu-ulevel

include ../../mk/spksrc.spk-python.mk

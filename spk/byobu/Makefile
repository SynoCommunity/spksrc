SPK_NAME = byobu
SPK_VERS = 6.13
SPK_REV = 1
SPK_ICON = src/byobu.png

DEPENDS = cross/byobu

include ../../mk/spksrc.common.mk

MAINTAINER = tofuhero
DESCRIPTION = Byobu is a GPLv3 open source text-based window manager and terminal multiplexer. It was originally designed to provide elegant enhancements to the otherwise functional, plain, practical GNU Screen, for the Ubuntu server distribution. Byobu now includes an enhanced profiles, convenient keybindings, configuration utilities, and toggle-able system status notifications for both the GNU Screen window manager and the more modern Tmux terminal multiplexer, and works on most Linux, BSD, and Mac distributions.
DISPLAY_NAME = byobu
STARTABLE = no
CHANGELOG = "Initial package release."

LICENSE  = GPLv3
HOMEPAGE = https://www.byobu.org/

SERVICE_USER = auto

SPK_COMMANDS  = bin/$(SPK_NAME)
SPK_COMMANDS += bin/$(SPK_NAME)-config
SPK_COMMANDS += bin/$(SPK_NAME)-ctrl-a
SPK_COMMANDS += bin/$(SPK_NAME)-disable
SPK_COMMANDS += bin/$(SPK_NAME)-disable-prompt
SPK_COMMANDS += bin/$(SPK_NAME)-enable
SPK_COMMANDS += bin/$(SPK_NAME)-enable-prompt
SPK_COMMANDS += bin/$(SPK_NAME)-export
SPK_COMMANDS += bin/$(SPK_NAME)-janitor
SPK_COMMANDS += bin/$(SPK_NAME)-launch
SPK_COMMANDS += bin/$(SPK_NAME)-launcher
SPK_COMMANDS += bin/$(SPK_NAME)-launcher-install
SPK_COMMANDS += bin/$(SPK_NAME)-launcher-uninstall
SPK_COMMANDS += bin/$(SPK_NAME)-layout
SPK_COMMANDS += bin/$(SPK_NAME)-prompt
SPK_COMMANDS += bin/$(SPK_NAME)-quiet
SPK_COMMANDS += bin/$(SPK_NAME)-reconnect-sockets
SPK_COMMANDS += bin/$(SPK_NAME)-select-backend
SPK_COMMANDS += bin/$(SPK_NAME)-select-profile
SPK_COMMANDS += bin/$(SPK_NAME)-select-session
SPK_COMMANDS += bin/$(SPK_NAME)-shell
SPK_COMMANDS += bin/$(SPK_NAME)-silent
SPK_COMMANDS += bin/$(SPK_NAME)-status
SPK_COMMANDS += bin/$(SPK_NAME)-status-detail
SPK_COMMANDS += bin/$(SPK_NAME)-ugraph
SPK_COMMANDS += bin/$(SPK_NAME)-ulevel

SPK_DEPENDS = "synocli-net"

include ../../mk/spksrc.spk.mk
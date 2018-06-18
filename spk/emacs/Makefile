SPK_NAME = emacs
SPK_VERS = 26.1
SPK_REV = 1
SPK_ICON = src/emacs.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = Tim Visher
DESCRIPTION = Emacs is the extensible, customizable, self-documenting real-time display editor.
RELOAD_UI = no
DISPLAY_NAME = Emacs
STARTABLE = no
BETA = 1
CHANGELOG = Add emacs 26.1

HOMEPAGE   = https://www.gnu.org/software/emacs/
LICENSE    = GPLv3

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = tmux_extra_install

include ../../mk/spksrc.spk.mk

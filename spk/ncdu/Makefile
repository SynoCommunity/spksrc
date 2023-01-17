SPK_NAME = ncdu
SPK_VERS = 1.12
SPK_REV = 1
SPK_ICON = src/ncdu.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = yeled
DESCRIPTION = Disk usage analyzer with an ncurses interface
RELOAD_UI = no
DISPLAY_NAME = ncdu
STARTABLE = no
CHANGELOG = "Initial release"

HOMEPAGE   = https://dev.yorhel.nl/ncdu
LICENSE    = MIT

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

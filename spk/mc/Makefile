SPK_NAME = mc
SPK_VERS = 4.8.10
SPK_REV = 2
SPK_ICON = src/mc.png

DEPENDS = cross/mc

MAINTAINER = SynoCommunity
DESCRIPTION = Midnight Commander is a console application with a text user interface. The main interface consists of two panels which display the file system.
DESCRIPTION_FRE = Midnight Commander est une application en mode texte. L\\\'interface principale se compose de deux « panneaux » qui affichent les fichiers présents par rapport à leur emplacement sur le disque.
RELOAD_UI = no
DISPLAY_NAME = Midnight Commander
STARTABLE = no
CHANGELOG = "1. Support UTF8 by default<br>2. UTF8 box drawing"

HOMEPAGE   = http://www.midnight-commander.org/
LICENSE    = GNU GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = mc_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: mc_extra_install
mc_extra_install:
	install -m 755 src/mc-utf8 $(STAGING_DIR)/bin/mc-utf8

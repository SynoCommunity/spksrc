SPK_NAME = midnightcommander
SPK_VERS = 4.8.6
SPK_REV = 1
SPK_ICON = src/mc.png
BETA = 1

DEPENDS = cross/mc

MAINTAINER = SynoCommunity
DESCRIPTION = Midnight Commander is a console application with a text user interface. The main interface consists of two panels which display the file system.
DESCRIPTION_FRE = Midnight Commander est une application en mode texte. L\\\'interface principale se compose de deux « panneaux » qui affichent les fichiers présents par rapport à leur emplacement sur le disque.
RELOAD_UI = no
DISPLAY_NAME = Midnight Commander

HOMEPAGE   = http://www.midnight-commander.org/
LICENSE    = GNU GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/start-stop-status
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
POST_STRIP_TARGET = xz-compress

include ../../mk/spksrc.spk.mk

.PHONY: xz-compress
xz-compress:
	install -m 755 -d $(STAGING_DIR)/log
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/bin/*.pl $(STAGING_DIR)/bin/
	

SPK_NAME = museek-plus
SPK_VERS = 0.2
SPK_REV = 1
SPK_ICON = src/museek+.png

DEPENDS = cross/busybox cross/museek+

MAINTAINER = Diaoul
DESCRIPTION = Museek+ is an open source file-sharing application for the ​Soulseek peer-to-peer network.
DESCRIPTION_FRE = Museek+ est une application de partage de fichier open source pour le réseau peer-to-peer Soulseek.
RELOAD_UI = yes
DISPLAY_NAME = Museek+
BETA = 1

HOMEPAGE = http://www.museek-plus.org/
LICENSE  = 

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = museek+_extra_install

BUSYBOX_CONFIG = usrmng daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: museek+_extra_install
museek+_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/config.xml $(STAGING_DIR)/var/

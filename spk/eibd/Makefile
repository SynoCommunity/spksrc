SPK_NAME = eibd
SPK_VERS = 0.0.5
SPK_REV = 1
SPK_ICON = src/eibd.png

DEPENDS = cross/busybox cross/pthsem cross/bcusdk

MAINTAINER   = SynoCommunity
DESCRIPTION  = "A Communication Stack for EIB/KNX by Martin Kögler (Config: /var/packages/eibd/etc/eibd.cfg)"
RELOAD_UI    = no
DISPLAY_NAME = eibd
CHANGELOG    = "First release for SynoCommunity"
HELPURL      = http://www.auto.tuwien.ac.at/~mkoegler/index.php/bcusdk
HOMEPAGE     = http://www.auto.tuwien.ac.at/~mkoegler/index.php/bcusdk
LICENSE      = GPL

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = eibd_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: bcusdk_extra_install
eibd_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/eibd.cfg $(STAGING_DIR)/var/eibd.cfg

SPK_NAME = transmission
SPK_VERS = 2.82
SPK_REV = 6
SPK_ICON = src/transmission.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Transmission is an easy and fast BitTorrent client. You can control it remotly with its web interface or dedicated applications.
DESCRIPTION_FRE = Transmission est un client BitTorrent simple et rapide. Vous pouvez le contrôler à distance grâce à son interface web ou des applications dédiées.
DESCRIPTION_SPN = Transmission es un cliente BitTorrent simple y rápido. Puedes controlarlo remotamente mediante su interfaz web o alguna aplicación dedicada.
ADMIN_PORT = 9091
RELOAD_UI = yes
DISPLAY_NAME = Transmission
CHANGELOG = "1. DSM 5.0 compatibility\n2. Check download directory exists on install\n3. Add incomplete dir configuration to wizard"

HOMEPAGE = http://www.transmissionbt.com/
LICENSE  =

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = transmission_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: transmission_extra_install
transmission_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/settings.json $(STAGING_DIR)/var/settings.json
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

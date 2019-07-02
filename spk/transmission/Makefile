SPK_NAME = transmission
SPK_VERS = 2.94
SPK_REV = 16
SPK_ICON = src/transmission.png

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = Safihre
DESCRIPTION = Transmission is an easy and fast BitTorrent client. You can control it remotely with its web interface or dedicated applications.
DESCRIPTION_FRE = Transmission est un client BitTorrent simple et rapide. Vous pouvez le contrôler à distance grâce à son interface web ou des applications dédiées.
DESCRIPTION_SPN = Transmission es un cliente BitTorrent simple y rápido. Puedes controlarlo remotamente mediante su interfaz web o alguna aplicación dedicada.
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Transmission
CHANGELOG = "1. Use DSM 5+6 generic service approach for correct permissions."

HOMEPAGE = http://www.transmissionbt.com
LICENSE  = GPLv2/GPLv3

WIZARDS_DIR      = src/wizard/

SERVICE_USER = auto
SERVICE_WIZARD_SHARE = wizard_download_dir
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 9091
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = transmission_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: transmission_extra_install
transmission_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/settings.json $(STAGING_DIR)/var/settings.json

SPK_NAME = transmission
SPK_VERS = 4.0.6
SPK_REV = 27
SPK_ICON = src/transmission.png

DEPENDS = cross/transmission

REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

MAINTAINER = SynoCommunity
DESCRIPTION = Transmission is an easy and fast BitTorrent client. You can control it remotely with its web interface or dedicated applications.
DESCRIPTION_FRE = Transmission est un client BitTorrent simple et rapide. Vous pouvez le contrôler à distance grâce à son interface web ou des applications dédiées.
DESCRIPTION_SPN = Transmission es un cliente BitTorrent simple y rápido. Puedes controlarlo remotamente mediante su interfaz web o alguna aplicación dedicada.
STARTABLE = yes
DISPLAY_NAME = Transmission
CHANGELOG = "Update Transmission to v4.0.6."

HOMEPAGE = https://transmissionbt.com
LICENSE  = GPLv2/GPLv3

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_WIZARD_SHARENAME = wizard_shared_folder_name
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 9091
SERVICE_PORT_TITLE = Transmission Web UI

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = transmission_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: transmission_extra_install
transmission_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/settings.json $(STAGING_DIR)/var/settings.json

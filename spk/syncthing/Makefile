SPK_NAME = syncthing
SPK_VERS = 1.15.1
SPK_REV = 21
SPK_ICON = src/syncthing.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = Safihre, acolomb
DESCRIPTION = Automatically sync files via secure, distributed technology.
DESCRIPTION_FRE = Synchronisation automatique de fichiers via une technologie sécurisée et distribuée.
DISPLAY_NAME = Syncthing
CHANGELOG = "Update to upstream version 1.15.1.  Clean up default config file template.  Drop DSM 5 support."
HOMEPAGE = https://www.syncthing.net
LICENSE = MPLv2.0
STARTABLE = yes

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8384
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

FWPORTS = src/${SPK_NAME}.sc

POST_STRIP_TARGET = syncthing_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: syncthing_extra_install
syncthing_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.xml $(STAGING_DIR)/var/config.xml
	install -m 644 src/options.conf $(STAGING_DIR)/var/options.conf

SPK_NAME = syncthing
SPK_VERS = 1.19.0
SPK_REV = 25
SPK_ICON = src/syncthing.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = acolomb
DESCRIPTION = Automatically sync files via secure, distributed technology.
DESCRIPTION_FRE = Synchronisation automatique de fichiers via une technologie sécurisée et distribuée.
DISPLAY_NAME = Syncthing
CHANGELOG = "1. Update syncthing to v1.19.0.<br/>2. Add wizard page to preconfigure credentials for the Web GUI.<br/>3. Integrate with the certificate management UI in Control Panel.<br/>4. Fix DSM 7 data migration."
HOMEPAGE = https://www.syncthing.net
LICENSE = MPLv2.0
STARTABLE = yes

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8384
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
SERVICE_CERT = syncthing_webui
SERVICE_CERT_RELOAD = tools/ca_reloader.sh

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

FWPORTS = src/${SPK_NAME}.sc

POST_STRIP_TARGET = syncthing_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: syncthing_extra_install
syncthing_extra_install:
	install -m 755 -d $(STAGING_DIR)/var $(STAGING_DIR)/tools
	install -m 600 src/config.xml $(STAGING_DIR)/var/
	install -m 644 src/options.conf $(STAGING_DIR)/var/
	install -m 700 src/ca_reloader.sh $(STAGING_DIR)/$(SERVICE_CERT_RELOAD)

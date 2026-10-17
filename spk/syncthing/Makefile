SPK_NAME = syncthing
SPK_VERS = 2.1.6
SPK_REV = 37
SPK_ICON = src/syncthing.png
DSM_UI_DIR = app

DEPENDS = cross/syncthing

# PPC: go has no 32-bit PowerPC target. ARMv5: syncthing 2.x requires go >= 1.24,
# which no longer runs on ARMv5 (1.30 was the last release that did, see #6762).
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS)
UNSUPPORTED_ARCHS_REASON = go has no 32-bit PowerPC target; syncthing 2.x requires go >= 1.24 (no ARMv5)

MAINTAINER = acolomb
DESCRIPTION = Automatically sync files via secure, distributed technology.
DESCRIPTION_FRE = Synchronisation automatique de fichiers via une technologie sécurisée et distribuée.
DISPLAY_NAME = Syncthing
CHANGELOG = "1. Update Syncthing to v2.1.6."
HOMEPAGE = https://www.syncthing.net
LICENSE = MPLv2.0
STARTABLE = yes

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8384
SERVICE_PORT_TITLE = Syncthing Web GUI
SERVICE_CERT = syncthing_webui
SERVICE_CERT_RELOAD = tools/ca_reloader.sh

# Admin link for in DSM Package Center
ADMIN_PORT = $(SERVICE_PORT)

FWPORTS = src/syncthing.sc

POST_STRIP_TARGET = syncthing_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: syncthing_extra_install
syncthing_extra_install:
	install -m 755 -d $(STAGING_DIR)/var $(STAGING_DIR)/tools
	install -m 600 src/config.xml $(STAGING_DIR)/var/
	install -m 644 src/options.conf $(STAGING_DIR)/var/
	install -m 700 src/ca_reloader.sh $(STAGING_DIR)/$(SERVICE_CERT_RELOAD)

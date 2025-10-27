SPK_NAME = syncthing
SPK_VERS = 1.30.0
SPK_REV = 32
SPK_ICON = src/syncthing.png
DSM_UI_DIR = app

DEPENDS = cross/syncthing

# archs not supported by go
UNSUPPORTED_ARCHS = $(PPC_ARCHS)

MAINTAINER = acolomb
DESCRIPTION = Automatically sync files via secure, distributed technology.
DESCRIPTION_FRE = Synchronisation automatique de fichiers via une technologie sécurisée et distribuée.
DISPLAY_NAME = Syncthing
CHANGELOG = "Build syncthing v1.30.0 with go v1.23 for final ARMv5 compatibility. <br/><br/>REMARKS: New packages are rarely created because syncthing's automatic package updater is used. <br/>On ARMv5 archs (i.e. DS213air, DS213, DS413j, DS112, DS112+, DS212, DS212+, RS212, RS812, DS212j, DS112j, DS111, DS211, DS211+, DS411slim, DS411, RS411, DS211j and DS411j) the automatic update is disabled. Further updates will not work, and manual use of the internal updater will result in a broken installation."
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

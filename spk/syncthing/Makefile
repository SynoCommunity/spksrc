SPK_NAME = syncthing
SPK_VERS = 2.0.13
SPK_REV = 33
SPK_ICON = src/syncthing.png
DSM_UI_DIR = app

DEPENDS = cross/syncthing

# archs not supported by go (ARMv5 requires legacy toolchain no longer provided)
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS)

MAINTAINER = acolomb
DESCRIPTION = Automatically sync files via secure, distributed technology.
DESCRIPTION_FRE = Synchronisation automatique de fichiers via une technologie sécurisée et distribuée.
DISPLAY_NAME = Syncthing
CHANGELOG = "1. Update Syncthing to v2.0.13 (built with Go 1.25). <br/>2. Drop legacy ARMv5 models that required the Go 1.23 compiler. <br/><br/>ATTENTION: This is a major version upgrade requiring a database migration on first launch. Please read the <a target=_blank href=https://github.com/syncthing/syncthing/releases/tag/v2.0.13>official release notes</a> and be prepared for some service downtime. <br/>REMARKS: New packages are rarely created because Syncthing's in-app updater is used."
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

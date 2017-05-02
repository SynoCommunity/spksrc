SPK_NAME = radarr
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 3
SPK_ICON = src/radarr.png
DSM_UI_DIR = app
BETA = 1

REQUIRED_DSM = 5.0
UNSUPPORTED_ARCHS = $(PPC_ARCHES)

DEPENDS = cross/busybox cross/curl cross/mediainfo cross/sqlite cross/radarr

SPK_DEPENDS = "mono>3.6"

MAINTAINER = ressu
DESCRIPTION  = Radarr is a movie manager like Couchpotato, but based on the Sonarr codebase. It can monitor multiple RSS feeds for new movie releases and will grab, sorts and rename them. It can also be configured to automatically upgrade the quality of files already downloaded if a better quality format becomes available.
ADMIN_PORT = 8310
RELOAD_UI = yes
DISPLAY_NAME = Radarr
CHANGELOG = "1. Update for DSM6 Compatibility"

HOMEPAGE = https://radarr.video/
LICENSE  = GPLv3

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/$(SPK_NAME).sc
CONF_DIR         = src/conf/
WIZARDS_DIR      = src/wizard/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = radarr_extra_install

BUSYBOX_CONFIG = usrmng daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: radarr_extra_install
radarr_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/config.xml $(STAGING_DIR)/app/config.xml

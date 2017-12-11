SPK_NAME = jackett
SPK_VERS = 0.7.1483
SPK_REV = 4
SPK_ICON = src/jackett.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/curl cross/$(SPK_NAME)
SPK_DEPENDS = "mono>=4.2.1.102-6"

MAINTAINER = SynoCommunity
DESCRIPTION = "Jackett works as a proxy server: it translates queries from apps into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software. Jackett is a single repository of maintained indexer scraping & translation logic - removing the burden from other apps."
ADMIN_PORT = 9117
RELOAD_UI = yes
DISPLAY_NAME = Jackett
BETA = 1
CHANGELOG = Updated to version 0.7.1483

HOMEPAGE = https://github.com/Jackett/Jackett
LICENSE  = GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/$(SPK_NAME).sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = jackett_extra_install

REQUIRED_DSM = 5.0
UNSUPPORTED_ARCHS = $(PPC_ARCHES)

BUSYBOX_CONFIG = usrmng daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: jackett_extra_install
jackett_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/.config
	install -m 755 -d $(STAGING_DIR)/var/.config/Jackett
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config

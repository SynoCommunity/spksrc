SPK_NAME = jackett
SPK_VERS = 0.11.43
SPK_REV = 8
SPK_ICON = src/jackett.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/curl cross/$(SPK_NAME)
# depend on mono 5.4 for BTLS HttpWebClient support
SPK_DEPENDS = "mono>=5.4"

MAINTAINER = m4tt075
DESCRIPTION = "Jackett works as a proxy server. It translates queries from apps into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software. Jackett is a single repository of maintained indexer scraping and translation logic - removing the burden from other apps."
RELOAD_UI = yes
DISPLAY_NAME = Jackett
BETA = 1
STARTABLE = yes
CHANGELOG = "Update Jackett to version 0.11.43"
HOMEPAGE = https://github.com/Jackett/Jackett
LICENSE = GPLv2

# 'auto' reserved value grabs SPK_NAME
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

# Service configuration
SERVICE_PORT = 9117
SERVICE_PORT_TITLE = Jackett(HTTP)

# Admin link
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = jackett_extra_install

REQUIRED_DSM = 5.0
# no PPC support for mono, see cross/mono/Makefile for details
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

SPK_NAME = jackett
SPK_VERS = 0.17.474
SPK_REV = 13
SPK_ICON = src/jackett.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = "Jackett works as a proxy server. It translates queries from apps into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software. Jackett is a single repository of maintained indexer scraping and translation logic - removing the burden from other apps."
RELOAD_UI = yes
DISPLAY_NAME = Jackett
STARTABLE = yes
CHANGELOG = "Update Jackett 17.474 and compile using .NET"
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

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

# Mono build for unsupported .NET archs
include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(i686_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
DEPENDS = cross/$(SPK_NAME)-mono
SERVICE_SETUP = src/service-setup-mono.sh
CHANGELOG = "Update Jackett 17.474 and fix mono build (88f6281 and 88f6282)"
endif

POST_STRIP_TARGET = jackett_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: jackett_extra_install
jackett_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/.config
	install -m 755 -d $(STAGING_DIR)/var/.config/Jackett

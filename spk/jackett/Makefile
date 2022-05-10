SPK_NAME = jackett
SPK_VERS = 0.20.1171
SPK_REV = 15
SPK_ICON = src/jackett.png
DSM_UI_DIR = app

DEPENDS = cross/libstdc++ cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = "Jackett works as a proxy server. It translates queries from apps into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software. Jackett is a single repository of maintained indexer scraping and translation logic - removing the burden from other apps."
DISPLAY_NAME = Jackett
STARTABLE = yes
CHANGELOG = "1. Update Jackett to 0.20.1171.<br/>2. Use .NET 6.0<br/>3. Fix DSM 7.1 Compatibility with self updater."
HOMEPAGE = https://github.com/Jackett/Jackett
LICENSE = GPLv2
LICENSE_FILE = $(WORK_DIR)/Jackett-$(SPK_VERS)/LICENSE

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
DEPENDS = cross/curl cross/$(SPK_NAME)-mono
SERVICE_SETUP = src/service-setup-mono.sh
CHANGELOG = "Update Jackett to 0.20.1171"
LICENSE_FILE = $(WORK_DIR)/Jackett/LICENSE
SPK_DEPENDS = "mono>3.6"
endif

POST_STRIP_TARGET = jackett_extra_install

# use alternate TMPDIR as /tmp might be too small and not accessible on DSM >= 7.1.
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.spk.mk

.PHONY: jackett_extra_install
jackett_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/.config
	install -m 755 -d $(STAGING_DIR)/var/.config/Jackett

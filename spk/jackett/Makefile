SPK_NAME = jackett
SPK_VERS = 0.20.3521
SPK_REV = 17
SPK_ICON = src/jackett.png
DSM_UI_DIR = app

DEPENDS = cross/libstdc++ cross/libicu cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
MAINTAINER_URL = https://synocommunity.com/
DESCRIPTION = "Jackett works as a proxy server. It translates queries from apps into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software. Jackett is a single repository of maintained indexer scraping and translation logic - removing the burden from other apps."
CHANGELOG = "1. Update Jackett to 0.20.3889.<br/>2. Add dotnet dependencies for DSM 7.2."
DISPLAY_NAME = Jackett
HOMEPAGE = https://github.com/Jackett/Jackett
LICENSE = GPLv2
LICENSE_FILE = $(WORK_DIR)/Jackett/LICENSE
HELPURL = https://github.com/Jackett/Jackett/wiki/Troubleshooting

STARTABLE = yes
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
include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(i686_ARCHS) $(ARMv7L_ARCHS) $(ARMv7_ARCHS)),$(ARCH))
DEPENDS = cross/curl cross/$(SPK_NAME)-mono
SERVICE_SETUP = src/service-setup-mono.sh
SPK_DEPENDS = "mono>=5.8"
endif
else
ifeq ($(findstring $(ARCH),$(i686_ARCHS) armada370 alpine alpine4k),$(ARCH))
DEPENDS = cross/curl cross/$(SPK_NAME)-mono
SERVICE_SETUP = src/service-setup-mono.sh
SPK_DEPENDS = "mono>=5.8"
else
UNSUPPORTED_ARCHS += armada370 alpine alpine4k
endif
endif

POST_STRIP_TARGET = jackett_extra_install

# use alternate TMPDIR as /tmp might be too small and not accessible on DSM >= 7.1.
# TMPDIR is used for jackett built in backup and update
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.spk.mk

.PHONY: jackett_extra_install
jackett_extra_install:
	@install -m 755 -d $(STAGING_DIR)/var/.config/Jackett

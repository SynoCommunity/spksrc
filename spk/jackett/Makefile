SPK_NAME = jackett
SPK_VERS = 0.22.534
SPK_REV = 18
SPK_ICON = src/jackett.png
DSM_UI_DIR = app

OPTIONAL_DEPENDS = cross/jackett cross/jackett-mono cross/libstdc++ cross/curl 

MAINTAINER = SynoCommunity
MAINTAINER_URL = https://synocommunity.com/
DESCRIPTION = "Jackett works as a proxy server. It translates queries from apps into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software. Jackett is a single repository of maintained indexer scraping and translation logic - removing the burden from other apps."
CHANGELOG = "1. Update Jackett to 0.22.534."
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
SERVICE_PORT_TITLE = Jackett (HTTP)

# Admin link
ADMIN_PORT = $(SERVICE_PORT)

UNSUPPORTED_ARCHS = $(PPC_ARCHS)
DSM7_ARMv7_ARCHS_DEPENDING_ON_MONO = armada370 alpine alpine4k

# Use Mono for unsupported .NET archs
include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(i686_ARCHS) $(ARMv7L_ARCHS) $(ARMv7_ARCHS)),$(ARCH))
DEPENDS = cross/curl cross/jackett-mono
SERVICE_SETUP = src/service-setup-mono.sh
SPK_DEPENDS = "mono>=5.8"
else
DEPENDS = cross/jackett
# dotnet requires libstdc++ version >= 6.0.22
DEPENDS += cross/libstdc++
endif
else
ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(DSM7_ARMv7_ARCHS_DEPENDING_ON_MONO)),$(ARCH))
DEPENDS = cross/curl cross/jackett-mono
SERVICE_SETUP = src/service-setup-mono.sh
SPK_DEPENDS = "mono>=5.8"
# create one package for all ARMv7 archs that depend on mono
SPK_PACKAGE_ARCHS = $(DSM7_ARMv7_ARCHS_DEPENDING_ON_MONO)
else
DEPENDS = cross/jackett
# exclude archs that depend on mono from generic package for ARMv7
UNSUPPORTED_ARCHS += $(DSM7_ARMv7_ARCHS_DEPENDING_ON_MONO)
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

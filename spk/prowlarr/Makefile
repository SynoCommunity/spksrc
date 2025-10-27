SPK_NAME = prowlarr
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 10
SPK_ICON = src/prowlarr.png

OPTIONAL_DEPENDS = cross/libstdc++ cross/libe_sqlite3
DEPENDS = cross/prowlarr

# Arch exclusions for dotnet
DOTNET_CORE_ARCHS = 1

MAINTAINER = Team Prowlarr
MAINTAINER_URL = https://prowlarr.com/
DESCRIPTION = Prowlarr is an indexer manager/proxy built on the popular arr .net/reactjs base stack to integrate with your various PVR apps. Prowlarr supports management of both Torrent Trackers and Usenet Indexers. It integrates seamlessly with Lidarr, Mylar3, Radarr, Readarr, and Sonarr offering complete management of your indexers with no per app Indexer setup required \(we do it all\).
CHANGELOG = "1. Update Prowlarr to v2.1.5.5216."
DISPLAY_NAME = Prowlarr
HOMEPAGE = https://prowlarr.com/
LICENSE  = GPLv3
LICENSE_FILE = $(WORK_DIR)/Prowlarr/LICENSE
HELPURL = https://wiki.servarr.com/prowlarr

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 9696
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

# use alternate TMPDIR as /tmp might be too small and not accessible on DSM >= 7.1.
# TMPDIR is used for prowlarr built in backup and update
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
# dotnet requires libstdc++ version >= 6.0.22
DEPENDS += cross/libstdc++
endif

ifeq ($(call version_lt, ${TCVERSION}, 7.2),1)
# Use libe_sqlite3 built for GLIBC 2.20–2.26 (DSM 6–7.1) instead of upstream ≥ 2.28
DEPENDS += cross/libe_sqlite3
POST_STRIP_TARGET += prowlarr_custom_libe_sqlite3
# Disable auto-update for DSM < 7.2
PROWLARR_UPDATE = disabled
endif

POST_STRIP_TARGET += prowlarr_extra_install

include ../../mk/spksrc.spk.mk

PACKAGE_VERSION = $(SPK_NAME_ARCH)-$(SPK_TCVERS)_$(SPK_VERS)-$(SPK_REV)
PACKAGE_AUTHOR = [SynoCommunity](https://synocommunity.com/)

.PHONY: prowlarr_custom_libe_sqlite3
prowlarr_custom_libe_sqlite3:
	@$(MSG) "Replace libe_sqlite3 with version built for DSM"
	mv -f $(STAGING_DIR)/lib/libe_sqlite3.so $(STAGING_DIR)/share/Prowlarr/bin/libe_sqlite3.so

.PHONY: prowlarr_extra_install
prowlarr_extra_install:
	@$(MSG) "Install config.xml and provide package_info."
	@install -m 755 -d $(STAGING_DIR)/var/.config/Prowlarr
	@install -m 644 src/config.xml $(STAGING_DIR)/var/.config/Prowlarr/config.xml
	@echo "PackageVersion=$(PACKAGE_VERSION)\nPackageAuthor=$(PACKAGE_AUTHOR)" > $(STAGING_DIR)/share/Prowlarr/package_info
	@if [ "$(PROWLARR_UPDATE)" = "disabled" ]; then \
		$(MSG) "Disable auto-update in package_info." ; \
		echo "UpdateMethod=External" >> $(STAGING_DIR)/share/Prowlarr/package_info ; \
	fi

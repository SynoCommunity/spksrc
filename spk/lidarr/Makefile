SPK_NAME = lidarr
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 16
SPK_ICON = src/lidarr.png

OPTIONAL_DEPENDS = cross/libstdc++ cross/libe_sqlite3
DEPENDS = cross/lidarr

# Arch exclusions for dotnet
DOTNET_CORE_ARCHS = 1

MAINTAINER = Team Lidarr
MAINTAINER_URL = https://lidarr.audio/
DESCRIPTION  = Lidarr is a music collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new tracks from your favorite artists and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
CHANGELOG = "1. Update Lidarr to v3.0.1.4866."
DISPLAY_NAME = Lidarr
HOMEPAGE = https://lidarr.audio/
LICENSE  = GPLv3
LICENSE_FILE = $(WORK_DIR)/Lidarr/LICENSE.md
HELPURL = https://wiki.servarr.com/Lidarr_Troubleshooting

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8686
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

# use alternate TMPDIR as /tmp might be too small and not accessible on DSM >= 7.1.
# TMPDIR is used for lidarr built in backup and update
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
# dotnet requires libstdc++ version >= 6.0.22
DEPENDS += cross/libstdc++
endif

ifeq ($(call version_lt, ${TCVERSION}, 7.2),1)
# Use libe_sqlite3 built for GLIBC 2.20–2.26 (DSM 6–7.1) instead of upstream ≥ 2.28
DEPENDS += cross/libe_sqlite3
POST_STRIP_TARGET += lidarr_custom_libe_sqlite3
# Disable auto-update for DSM < 7.2
LIDARR_UPDATE = disabled
endif

POST_STRIP_TARGET += lidarr_extra_install

include ../../mk/spksrc.spk.mk

PACKAGE_VERSION = $(SPK_NAME_ARCH)-$(SPK_TCVERS)_$(SPK_VERS)-$(SPK_REV)
PACKAGE_AUTHOR = [SynoCommunity](https://synocommunity.com/)

.PHONY: lidarr_custom_libe_sqlite3
lidarr_custom_libe_sqlite3:
	@$(MSG) "Replace libe_sqlite3 with version built for DSM"
	mv -f $(STAGING_DIR)/lib/libe_sqlite3.so $(STAGING_DIR)/share/Lidarr/bin/libe_sqlite3.so

.PHONY: lidarr_extra_install
lidarr_extra_install:
	@$(MSG) "Install config.xml and provide package_info."
	@install -m 755 -d $(STAGING_DIR)/var/.config/Lidarr
	@install -m 644 src/config.xml $(STAGING_DIR)/var/.config/Lidarr/config.xml
	@echo "PackageVersion=$(PACKAGE_VERSION)\nPackageAuthor=$(PACKAGE_AUTHOR)" > $(STAGING_DIR)/share/Lidarr/package_info
	@if [ "$(LIDARR_UPDATE)" = "disabled" ]; then \
		$(MSG) "Disable auto-update in package_info." ; \
		echo "UpdateMethod=External" >> $(STAGING_DIR)/share/Lidarr/package_info ; \
	fi

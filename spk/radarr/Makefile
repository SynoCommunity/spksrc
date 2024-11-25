SPK_NAME = radarr
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 22
SPK_ICON = src/radarr.png

OPTIONAL_DEPENDS = cross/libstdc++
DEPENDS = cross/radarr

# Arch exclusions for dotnet 6.0
DOTNET_SERVARR_ARCHS = 1

MAINTAINER = Team Radarr
MAINTAINER_URL = https://radarr.video/
DESCRIPTION = Radarr is a movie collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new movies and will interface with clients and indexers to grab, sort, and rename them. It can also be configured to automatically upgrade the quality of existing files in the library when a better quality format becomes available.
CHANGELOG = "1. Update Radarr to v5.12.2.9335."
DISPLAY_NAME = Radarr
HOMEPAGE = https://radarr.video/
LICENSE = GPLv3
LICENSE_FILE = $(WORK_DIR)/Radarr/LICENSE
HELPURL = https://wiki.servarr.com/Radarr

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8310
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = radarr_extra_install

# use alternate TMPDIR as /tmp might be too small and not accessible on DSM >= 7.1.
# TMPDIR is used for radarr built in backup and update
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
# dotnet requires libstdc++ version >= 6.0.22
DEPENDS += cross/libstdc++
endif

include ../../mk/spksrc.spk.mk

PACKAGE_VERSION = $(SPK_NAME_ARCH)-$(SPK_TCVERS)_$(SPK_VERS)-$(SPK_REV)
PACKAGE_AUTHOR = [Team Radarr](https://radarr.video)

.PHONY: radarr_extra_install
radarr_extra_install:
	@$(MSG) "Install config.xml and provide package_info."
	@install -m 755 -d $(STAGING_DIR)/var/.config/Radarr
	@install -m 644 src/config.xml $(STAGING_DIR)/var/.config/Radarr/config.xml
	@echo "PackageVersion=$(PACKAGE_VERSION)\nPackageAuthor=$(PACKAGE_AUTHOR)" > $(STAGING_DIR)/share/Radarr/package_info

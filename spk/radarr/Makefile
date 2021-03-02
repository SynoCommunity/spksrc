SPK_NAME = radarr
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 15
SPK_ICON = src/radarr.png

REQUIRED_DSM = 5.0

# .NET is not support on PPC, ARM5 or x86
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARM5_ARCHES) $(x86_ARCHES)

DEPENDS = cross/libstdc++ cross/libmediainfo cross/sqlite cross/radarr

MAINTAINER = Team Radarr
HELPURL    = https://wiki.servarr.com/Radarr
SUPPORTURL = https://radarr.video/\#support

DESCRIPTION = Radarr is a movie collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new movies and will interface with clients and indexers to grab, sort, and rename them. It can also be configured to automatically upgrade the quality of existing files in the library when a better quality format becomes available.
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Radarr
CHANGELOG = "Update Radarr to v3.0.2.4552 .NET Core"

HOMEPAGE = https://radarr.video/
LICENSE  = GPLv3

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8310
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = radarr_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: radarr_extra_install
radarr_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/config.xml $(STAGING_DIR)/app/config.xml
	echo "PackageVersion=$(SPK_NAME_ARCH)-$(SPK_TCVERS)_$(SPK_VERS)-$(SPK_REV)\nPackageAuthor=[Team Radarr](https://radarr.video)" > $(STAGING_DIR)/share/Radarr/package_info

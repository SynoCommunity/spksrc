SPK_NAME = prowlarr
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 4
SPK_ICON = src/prowlarr.png

UNSUPPORTED_ARCHS = $(DOTNET_UNSUPPORTED_ARCHS)

DEPENDS = cross/libstdc++ cross/prowlarr

MAINTAINER = Team Prowlarr
MAINTAINER_URL = https://prowlarr.com/
HELPURL    = https://wiki.servarr.com/prowlarr
# Placeholder support URL
SUPPORTURL = https://prowlarr.com/\#support

DESCRIPTION = Prowlarr is an indexer manager/proxy built on the popular arr .net/reactjs base stack to integrate with your various PVR apps. Prowlarr supports management of both Torrent Trackers and Usenet Indexers. It integrates seamlessly with Lidarr, Mylar3, Radarr, Readarr, and Sonarr offering complete management of your indexers with no per app Indexer setup required \(we do it all\).
DISPLAY_NAME = Prowlarr
CHANGELOG = "1. Enlarge the service start/stop timeout to 90 seconds.<br/>2. Update Prowlarr to v0.4.10.2111.<br/>3. Avoid Prowlarr downgrade on package update."

HOMEPAGE = https://prowlarr.com/
LICENSE  = GPLv3

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 9696
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = prowlarr_extra_install

# use alternate TMPDIR as /tmp might be too small and not accessible on DSM >= 7.1.
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.spk.mk

PACKAGE_VERSION = $(SPK_NAME_ARCH)-$(SPK_TCVERS)_$(SPK_VERS)-$(SPK_REV)
PACKAGE_AUTHOR = [Team Prowlarr](https://prowlarr.com)

.PHONY: prowlarr_extra_install
prowlarr_extra_install:
	@install -m 755 -d $(STAGING_DIR)/var/.config/Prowlarr
	@install -m 644 src/config.xml $(STAGING_DIR)/var/.config/Prowlarr/config.xml
	@echo "PackageVersion=$(PACKAGE_VERSION)\nPackageAuthor=$(PACKAGE_AUTHOR)" > $(STAGING_DIR)/share/Prowlarr/package_info

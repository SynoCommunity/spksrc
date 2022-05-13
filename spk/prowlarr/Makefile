SPK_NAME = prowlarr
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 2
SPK_ICON = src/prowlarr.png

# .NET is not supported on PPC, ARM5, ARM7L and x86
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(i686_ARCHS)

DEPENDS = cross/libstdc++ cross/prowlarr

MAINTAINER = Team Prowlarr
MAINTAINER_URL = https://prowlarr.com/
HELPURL    = https://wiki.servarr.com/prowlarr
# Placeholder support URL
SUPPORTURL = https://prowlarr.com/\#support

DESCRIPTION = Prowlarr is an indexer manager/proxy built on the popular arr .net/reactjs base stack to integrate with your various PVR apps. Prowlarr supports management of both Torrent Trackers and Usenet Indexers. It integrates seamlessly with Lidarr, Mylar3, Radarr, Readarr, and Sonarr offering complete management of your indexers with no per app Indexer setup required \(we do it all\).
STARTABLE = yes
DISPLAY_NAME = Prowlarr
CHANGELOG = "1. Update prowlarr to v0.2.0.1678.<br/>2. Fix DSM service status.<br/>3. User package date for version since internal updater is used."

HOMEPAGE = https://prowlarr.com/
LICENSE  = GPLv3

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
	@install -m 755 -d $(STAGING_DIR)/app
	@install -m 644 src/config.xml $(STAGING_DIR)/app/config.xml
	@echo "PackageVersion=$(PACKAGE_VERSION)\nPackageAuthor=$(PACKAGE_AUTHOR)" > $(STAGING_DIR)/share/Prowlarr/package_info

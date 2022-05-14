SPK_NAME = radarr
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 18
SPK_ICON = src/radarr.png

REQUIRED_MIN_DSM = 5.0

# .NET is not supported on PPC, ARM5, ARM7L and x86
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(i686_ARCHS)

DEPENDS = cross/libstdc++ cross/libmediainfo cross/sqlite cross/radarr

MAINTAINER = Team Radarr
MAINTAINER_URL = https://radarr.video/
HELPURL = https://wiki.servarr.com/Radarr
SUPPORTURL = https://radarr.video/\#support

DESCRIPTION = Radarr is a movie collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new movies and will interface with clients and indexers to grab, sort, and rename them. It can also be configured to automatically upgrade the quality of existing files in the library when a better quality format becomes available.
STARTABLE = yes
DISPLAY_NAME = Radarr
CHANGELOG = "1. Update Radarr to v3.2.2.5080 .NET Core.<br/>2. Use writable temp folder to fix internal updates on DSM >= 7.1.<br/>3. Fix config folder migration for DSM 7."

HOMEPAGE = https://radarr.video/
LICENSE = GPLv3

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8310
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = radarr_extra_install

# use alternate TMPDIR as /tmp might be too small and not accessible on DSM >= 7.1.
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.spk.mk

PACKAGE_VERSION = $(SPK_NAME_ARCH)-$(SPK_TCVERS)_$(SPK_VERS)-$(SPK_REV)
PACKAGE_AUTHOR = [Team Radarr](https://radarr.video)

.PHONY: radarr_extra_install
radarr_extra_install:
	@install -m 755 -d $(STAGING_DIR)/app
	@install -m 644 src/config.xml $(STAGING_DIR)/app/config.xml
	@echo "PackageVersion=$(PACKAGE_VERSION)\nPackageAuthor=$(PACKAGE_AUTHOR)" > $(STAGING_DIR)/share/Radarr/package_info

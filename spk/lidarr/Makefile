SPK_NAME = lidarr
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 11
SPK_ICON = src/lidarr.png

DEPENDS = cross/lidarr cross/libstdc++ cross/sqlite

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

MAINTAINER = Team Lidarr
MAINTAINER_URL = https://lidarr.audio/
DESCRIPTION  = Lidarr is a music collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new tracks from your favorite artists and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
CHANGELOG = "1. Fix package update.<br>2. Add support for x86 (32-bit) architecture."
DISPLAY_NAME = Lidarr
HOMEPAGE = https://lidarr.audio/
LICENSE  = GPLv3
LICENSE_FILE = $(WORK_DIR)/Lidarr/LICENSE.md
HELPURL = https://wiki.servarr.com/Lidarr_Troubleshooting
SUPPORTURL = https://lidarr.audio/\#support

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8686
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = lidarr_extra_install

# use alternate TMPDIR as /tmp might be too small and not accessible on DSM >= 7.1.
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.spk.mk

PACKAGE_VERSION = $(SPK_NAME_ARCH)-$(SPK_TCVERS)_$(SPK_VERS)-$(SPK_REV)
PACKAGE_AUTHOR = [Team Lidarr](https://lidarr.audio/)

.PHONY: lidarr_extra_install
lidarr_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/.config/Lidarr
	install -m 644 src/config.xml $(STAGING_DIR)/var/.config/Lidarr/config.xml
	@echo "PackageVersion=$(PACKAGE_VERSION)\nPackageAuthor=$(PACKAGE_AUTHOR)" > $(STAGING_DIR)/share/Lidarr/package_info

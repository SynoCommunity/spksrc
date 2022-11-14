SPK_NAME = lidarr
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 10
SPK_ICON = src/lidarr.png

DEPENDS = cross/lidarr cross/libstdc++ cross/sqlite

UNSUPPORTED_ARCHS = $(DOTNET_UNSUPPORTED_ARCHS)

MAINTAINER = Team Lidarr
MAINTAINER_URL = https://lidarr.audio/
DESCRIPTION  = Lidarr is a music collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new tracks from your favorite artists and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
CHANGELOG = "1. Update Lidarr to v1.0.2.<br/>2. Use alternate TMP directory to provide enough space for internal updater.<br/>3. Enlarge the service start/stop timeout to 90 seconds.<br/>4. Avoid Lidarr downgrade on package update."
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
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/config.xml $(STAGING_DIR)/app/config.xml
	@echo "PackageVersion=$(PACKAGE_VERSION)\nPackageAuthor=$(PACKAGE_AUTHOR)" > $(STAGING_DIR)/share/Lidarr/package_info

SPK_NAME = lidarr
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 2
SPK_ICON = src/lidarr.png

REQUIRED_DSM = 5.0
# Mono not supported on ppc platforms. C.f. cross/mono/Makefile and references therein for details.
UNSUPPORTED_ARCHS = $(PPC_ARCHES)

DEPENDS = cross/curl cross/mediainfo cross/sqlite cross/lidarr

SPK_DEPENDS = "mono>3.6"

MAINTAINER = Safihre
DESCRIPTION  = Lidarr is a music collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new tracks from your favorite artists and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Lidarr
CHANGELOG = "Update Lidarr to v0.5.0.583"

HOMEPAGE = http://lidarr.audio/
LICENSE  = GPLv3

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8686
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = lidarr_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: lidarr_extra_install
lidarr_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/config.xml $(STAGING_DIR)/app/config.xml

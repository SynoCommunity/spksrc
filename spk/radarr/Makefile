SPK_NAME = radarr
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 8
SPK_ICON = src/radarr.png

REQUIRED_DSM = 5.0
# Mono not supported on ppc platforms. C.f. cross/mono/Makefile and references therein for details.
UNSUPPORTED_ARCHS = $(PPC_ARCHES)

DEPENDS = cross/busybox cross/curl cross/mediainfo cross/sqlite cross/radarr

SPK_DEPENDS = "mono>3.6"

MAINTAINER = ressu
DESCRIPTION  = Radarr is a movie manager like Couchpotato, but based on the Sonarr codebase. It can monitor multiple RSS feeds for new movie releases and will grab, sorts and rename them. It can also be configured to automatically upgrade the quality of files already downloaded if a better quality format becomes available.
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Radarr
CHANGELOG = "Update Radarr to v0.2.0.1293."

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

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: radarr_extra_install
radarr_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/config.xml $(STAGING_DIR)/app/config.xml

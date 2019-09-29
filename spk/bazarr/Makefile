SPK_NAME = bazarr

SPK_VERS = 0.9.1.1
SPK_REV = 1

SPK_ICON = src/bazarr.png

BUILD_DEPENDS = cross/python38

DEPENDS = cross/$(SPK_NAME)

WHEELS = 
SPK_DEPENDS = "python38:ffmpeg"

MAINTAINER = smaarn

DESCRIPTION = "Bazarr is a companion application to Sonarr and Radarr. It manages and downloads subtitles based on your requirements. You define your preferences by TV show or movies and Bazarr takes care of everything for you."
RELOAD_UI = no
DISPLAY_NAME = Bazarr
STARTABLE = yes
CHANGELOG = "Initial release"

HOMEPAGE = https://www.bazarr.media
LICENSE = GPLv3

SERVICE_USER  = auto
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT  = 6767
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
SERVICE_COMMAND = /var/packages/$(SPK_NAME)/target/bin/$(SPK_NAME)-daemon
# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = bazarr_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: bazarr_extra_install
bazarr_extra_install:
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/bin/bazarr-daemon $(STAGING_DIR)/bin/bazarr-daemon

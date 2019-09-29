SPK_NAME = bazarr
SPK_VERS = 0.8.2.4
SPK_REV = 2

SPK_ICON = src/bazarr.png

REQUIRED_DSM = 6.1

BUILD_DEPENDS = cross/python cross/setuptools cross/pip cross/wheel

BETA = 1

DEPENDS = cross/busybox
DEPENDS += cross/libxml2 
DEPENDS += cross/libxslt 
DEPENDS += cross/libicu 
DEPENDS += cross/sqlite
DEPENDS += cross/$(SPK_NAME)

WHEELS = "lxml==4.3.0"
SPK_DEPENDS = "python>=2.7.13:git"

MAINTAINER = SynoCommunity

DESCRIPTION = "Bazarr is a companion application to Sonarr and Radarr. It manages and downloads subtitles based on your requirements. You define your preferences by TV show or movies and Bazarr takes care of everything for you."
RELOAD_UI = no
DISPLAY_NAME = Bazarr
STARTABLE = yes
CHANGELOG = "Initial release"

HOMEPAGE = https://www.bazarr.media
LICENSE = GPLv3

SERVICE_USER  = auto
SERVICE_SETUP = src/service-setup.sh
SSS_SCRIPT    = src/dsm-control.sh
SERVICE_PORT  = 6767
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

BUSYBOX_CONFIG = daemon nice
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

POST_STRIP_TARGET = bazarr_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: bazarr_extra_install
bazarr_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 src/settings.sh $(STAGING_DIR)/bin/settings.sh

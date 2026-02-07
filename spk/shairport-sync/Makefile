SPK_NAME = shairport-sync
SPK_VERS = 4.3.7
SPK_REV = 3
SPK_ICON = src/shairport-sync.png

DEPENDS = cross/shairport-sync

MAINTAINER = SynoCommunity
DESCRIPTION = AirPlay audio player. Stream audio wirelessly from Apple devices to your Synology NAS. Requires USB soundcard or speakers connected to your NAS.
DISPLAY_NAME = Shairport Sync
CHANGELOG = "1. Update to v4.3.7 with metadata support. <br/>2. Modernize for DSM 7."

HOMEPAGE = https://github.com/mikebrady/shairport-sync
LICENSE = GPL

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

FWPORTS = src/shairport-sync.sc
WIZARDS_DIR = src/wizard

POST_STRIP_TARGET = shairport_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: shairport_extra_install
shairport_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/share/alsa
	install -m 644 src/alsa.conf $(STAGING_DIR)/share/alsa/alsa.conf
	install -m 644 src/shairport-sync.conf $(STAGING_DIR)/var/shairport-sync.conf

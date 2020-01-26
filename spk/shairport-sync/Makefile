SPK_NAME = shairport-sync
SPK_VERS = 2.8.6
SPK_REV = 3
SPK_ICON = src/shairport-sync.png

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = AirPlay audio player. Shairport Sync adds multi-room capability with Audio Synchronisation. Requires USB soundcard or speakers.
DISPLAY_NAME = Shairport Sync
CHANGELOG = "1. Fix DSM 6 service installation<br/>2. Update to 2.8.6"

HOMEPAGE = https://github.com/mikebrady/shairport-sync
LICENSE  = https://github.com/mikebrady/shairport-sync/blob/master/COPYING
STARTABLE = yes

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SSS_SCRIPT = src/dsm-control.sh
FWPORTS = src/${SPK_NAME}.sc

POST_STRIP_TARGET = shairport_extra_install

ENV += BUSYBOX_CONFIG="daemon usrmng"

include ../../mk/spksrc.spk.mk

.PHONY: shairport_extra_install
shairport_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/run
	install -m 644 src/alsa.conf $(STAGING_DIR)/share/alsa/alsa.conf
	install -m 644 src/shairport-sync.conf $(STAGING_DIR)/var/shairport-sync.conf

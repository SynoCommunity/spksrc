SPK_NAME = shairport-sync
SPK_VERS = 3.3.9
SPK_REV = 3
SPK_ICON = src/shairport-sync.png

DEPENDS = cross/shairport-sync

MAINTAINER = SynoCommunity
DESCRIPTION = AirPlay audio player. Shairport Sync adds multi-room capability with Audio Synchronisation. Requires USB soundcard or speakers.
DISPLAY_NAME = Shairport Sync
CHANGELOG = "1. Update to v3.3.9.<br/>2. Update for DSM 7 compatibility.<br/>3. Fix DSM 6 service installation.<br/>4. Add soxr support.<br/>5. Add convolution filter support except for limitted CPUs."

HOMEPAGE = https://github.com/mikebrady/shairport-sync
LICENSE  = Please refer to the individual source files for licenses.
STARTABLE = yes

SERVICE_USER = auto
FWPORTS = src/shairport-sync.sc

# the path of the pid file must be configured in the configfile
# (sessioncontrol.daemon_pid_dir) as "/var/packages/shairport-sync/var"
SERVICE_COMMAND = $${SYNOPKG_PKGDEST}/bin/shairport-sync --daemon --configfile=$${SYNOPKG_PKGVAR}/shairport-sync.conf

POST_STRIP_TARGET = shairport_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: shairport_extra_install
shairport_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/alsa.conf $(STAGING_DIR)/share/alsa/alsa.conf
	install -m 644 src/shairport-sync.conf $(STAGING_DIR)/var/shairport-sync.conf

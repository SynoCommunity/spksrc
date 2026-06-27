SPK_NAME = shairport-sync
SPK_VERS = 4.3.7
SPK_REV = 3
SPK_ICON = src/shairport-sync.png

DEPENDS = cross/shairport-sync

# Require AudioStation for USB audio driver support on DSM 6
SPK_DEPENDS = "AudioStation"

# DSM 6 only - DSM 7 does not allow packages to run as root
# which is required for ALSA device access
REQUIRED_MAX_DSM = 6.999

MAINTAINER = SynoCommunity
DESCRIPTION = AirPlay 2 audio player. Stream audio wirelessly from Apple devices to your Synology NAS using Apple\'s latest AirPlay 2 protocol. Features include multi-room audio, Siri integration, and improved reliability. Requires USB soundcard or speakers connected to your NAS.
DISPLAY_NAME = Shairport Sync
CHANGELOG = "1. Update to v4.3.7 with AirPlay 2 support.<br/>2. Added NQPTP daemon for AirPlay 2 timing.<br/>3. DSM 6 only - requires AudioStation for USB audio drivers."

HOMEPAGE = https://github.com/mikebrady/shairport-sync
LICENSE = GPL

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
CONF_DIR = src/conf

FWPORTS = src/shairport-sync.sc
WIZARDS_DIR = src/wizard

POST_STRIP_TARGET = shairport_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: shairport_extra_install
shairport_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/share
	install -m 644 src/alsa.conf $(STAGING_DIR)/share/alsa.conf
	install -m 644 src/shairport-sync.conf.template $(STAGING_DIR)/share/shairport-sync.conf.template

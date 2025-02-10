SPK_NAME = mpd
SPK_VERS = 0.23.15
SPK_REV = 2
SPK_ICON = src/mpd.png
DSM_UI_DIR = app

DEPENDS = cross/mpd

REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

MAINTAINER = hgy59
DESCRIPTION = Music Player Daemon \(MPD\) is a flexible, powerful, server-side application for playing music. Through plugins and libraries it can play a variety of sound files while being controlled by its network protocol.
CHANGELOG = "Update mpd to v0.23.15, available for DSM 7 only."

DISPLAY_NAME = Music Player Daemon

HOMEPAGE = https://www.musicpd.org/
LICENSE = GPLv2

WIZARDS_DIR = src/wizards

# SERVICE_COMMAND is defined in service-setup.sh
STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
NO_SERVICE_SHORTCUT = yes

SERVICE_WIZARD_SHARENAME = wizard_music_folder
FWPORTS = src/mpd.sc

POST_STRIP_TARGET = mpd_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: mpd_extra_install
mpd_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/mpd.conf $(STAGING_DIR)/var/mpd.conf

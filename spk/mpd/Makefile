SPK_NAME = mpd
SPK_VERS = 0.24.8
SPK_REV = 4
SPK_ICON = src/mpd.png
DSM_UI_DIR = app

DEPENDS = cross/mpd cross/mpc

REQUIRED_MIN_DSM = 7.2
UNSUPPORTED_ARCHS = comcerto2k
REQUIRED_MIN_SRM = 1.3

MAINTAINER = hgy59
DESCRIPTION = Music Player Daemon \(MPD\) is a flexible, powerful, server-side application for playing music. Through plugins and libraries it can play a variety of sound files while being controlled by its network protocol.
CHANGELOG = "1. Update MPD to v0.24.8 (requires DSM 7.2+ for C++20 support). <br/>2. Include mpc command-line client for diagnostics."

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

SPK_COMMANDS = bin/mpc

POST_STRIP_TARGET = mpd_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: mpd_extra_install
mpd_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/mpd.conf $(STAGING_DIR)/var/mpd.conf

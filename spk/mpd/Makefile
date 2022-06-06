SPK_NAME = mpd
SPK_VERS = 0.20.23
SPK_REV = 1
SPK_ICON = src/mpd.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

# A compiler with support for C++14 language features is required.
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)

MAINTAINER = DigitalBox98
DESCRIPTION = Music Player Daemon \(MPD\) is a flexible, powerful, server-side application for playing music. Through plugins and libraries it can play a variety of sound files while being controlled by its network protocol.
CHANGELOG = "Initial package release."

DISPLAY_NAME = Music Player Daemon

HOMEPAGE   = https://www.musicpd.org/
LICENSE    = GPLv2

WIZARDS_DIR = src/wizards

# SERVICE_COMMAND is defined in service-setup.sh
STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
NO_SERVICE_SHORTCUT = yes

SERVICE_WIZARD_SHARE = wizard_music_folder
USE_DATA_SHARE_WORKER = yes
FWPORTS = src/mpd.sc

POST_STRIP_TARGET = mpd_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: mpd_extra_install
mpd_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/mpd.conf $(STAGING_DIR)/var/mpd.conf

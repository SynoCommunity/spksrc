SPK_NAME = mpd
SPK_VERS = 0.20.23
SPK_REV = 1
SPK_ICON = src/mpd.png
DSM_UI_DIR = app

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = DigitalBox98
DESCRIPTION = A daemon for playing music of various formats

RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = MPD

HOMEPAGE   = https://www.musicpd.org/
LICENSE    = GPLv2

WIZARDS_DIR = WIZARD_UIFILES

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
NO_SERVICE_SHORTCUT = yes

POST_STRIP_TARGET = mpd_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: mpd_extra_install
mpd_extra_install:
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 644 src/mpd.conf $(STAGING_DIR)/etc/mpd.conf


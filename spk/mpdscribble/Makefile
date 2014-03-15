SPK_NAME = mpdscribble
SPK_VERS = 0.22
SPK_REV = 1
SPK_ICON = src/mpdscribble.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = An audioscrobbler for the Music Player Daemon.
DESCRIPTION_FRE = Un audioscrobbler pour le Music Player Daemon.
RELOAD_UI = yes
DISPLAY_NAME = MPDScribble
BETA = 1

HOMEPAGE = http://www.musicpd.org/
LICENSE  = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = mpdscribble_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: mpdscribble_extra_install
mpdscribble_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/mpdscribble.conf $(STAGING_DIR)/var/mpdscribble.conf

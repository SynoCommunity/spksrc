SPK_NAME = mpd
SPK_VERS = 0.17.6
SPK_REV = 1
SPK_ICON = src/mpd.png

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Music Player Daemon is a flexible, powerful, server-side application for playing music.
DESCRIPTION_FRE = Music Player Daemon est un serveur de lecture audio flexible et puissant.
RELOAD_UI = yes
DISPLAY_NAME = Music Player Daemon
BETA = 1

HOMEPAGE = http://www.musicpd.org/
LICENSE  = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = mpd_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: mpd_extra_install
mpd_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/{music,playlists}
	install -m 600 src/mpd.conf $(STAGING_DIR)/var/mpd.conf

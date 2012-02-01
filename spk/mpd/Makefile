SPK_NAME = mpd
SPK_VERS = 0.16.6
SPK_REV = 1
SPK_ICON = src/mpd.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = http://packages.nas-forum.com
COMMENT    = Music Player Daemon
RELOAD_UI = yes
DISPLAY_NAME = Music Player Daemon (MPD) is a flexible, powerful, server-side application for playing music. Through plugins and libraries it can play a variety of sound files while being controlled by its network protocol.

HOMEPAGE   = http://mpd.wikia.com/
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = musicpd_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: musicpd_extra_install
musicpd_extra_install:
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/mpd.conf $(STAGING_DIR)/etc/mpd.conf


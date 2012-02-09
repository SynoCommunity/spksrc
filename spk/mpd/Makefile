SPK_NAME = mpd
SPK_VERS = 0.16.6
SPK_REV = 1
SPK_ICON = src/mpd.png
DSM_UI_DIR = app
DSM_APP_NAME = MPD.Instance

DEPENDS = cross/$(SPK_NAME)

SPK_DEPENDS = "Python27>=2.7.2-1"

MAINTAINER = http://packages.nas-forum.com
COMMENT    = Music Player Daemon is a flexible, powerful, server-side application for playing music. Through plugins and libraries it can play a variety of sound files while being controlled by its network protocol.
RELOAD_UI = yes
DISPLAY_NAME = Music Player Daemon

HOMEPAGE   = http://mpd.wikia.com/
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = mpd_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: mpd_extra_install
mpd_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/playlists
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 644 src/mpd.conf $(STAGING_DIR)/etc/mpd.conf
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/app/index.conf $(STAGING_DIR)/app/index.conf
	install -m 644 src/app/mpd.js $(STAGING_DIR)/app/mpd.js
	install -m 755 src/app/mpd.cgi.py $(STAGING_DIR)/app/mpd.cgi
	install -m 755 -d $(STAGING_DIR)/app/texts
	for language in enu fre; do \
		install -m 755 -d $(STAGING_DIR)/app/texts/$${language}; \
		install -m 644 src/app/texts/$${language}/strings $(STAGING_DIR)/app/texts/$${language}/strings; \
	done
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} -transparent white \
		        $(STAGING_DIR)/app/images/mpd-$${size}.png ; \
	done


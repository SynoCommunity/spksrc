SPK_NAME = deluge
SPK_VERS = 1.3.15
SPK_REV = 9
SPK_ICON = src/deluge.png
BETA = 1

BUILD_DEPENDS = cross/python cross/setuptools cross/pip cross/wheel
DEPENDS  = cross/libtorrent cross/$(SPK_NAME)
WHEELS = characteristic chardet pyasn1-modules pyxdg Mako service-identity
SPK_DEPENDS = "python>=2.7.6-8"

REQUIRED_DSM = 5.0

MAINTAINER = Safihre
DESCRIPTION = Deluge is a full-featured  BitTorrent client for Linux, OS X, Unix and Windows. It uses libtorrent in its backend and features multiple user-interfaces including: GTK+, web and console. It has been designed using the client server model with a daemon process that handles all the bittorrent activity. The Deluge daemon is able to run on headless machines with the user-interfaces being able to connect remotely from any platform. This package is intended for advanced users.
RELOAD_UI = yes
STARTABLE = yes
CHANGELOG = Update dependencies
DISPLAY_NAME = Deluge

HOMEPAGE = http://deluge-torrent.org
LICENSE  = GPL
HELPURL  = http://dev.deluge-torrent.org/wiki/UserGuide

# Custom start-stop script needed due to double-deamon
SSS_SCRIPT       = src/dsm-control.sh
WIZARDS_DIR      = src/wizard/

SERVICE_USER = auto
SERVICE_WIZARD_SHARE = wizard_download_dir
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8112
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = deluge_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: deluge_extra_install
deluge_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/core.conf $(STAGING_DIR)/var/core.conf

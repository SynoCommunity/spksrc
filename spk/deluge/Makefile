SPK_NAME = deluge
SPK_VERS = 1.3.13
SPK_REV = 6
SPK_ICON = src/deluge.png
DSM_UI_DIR = app
BETA = 1

BUILD_DEPENDS = cross/python cross/setuptools cross/pip cross/wheel
DEPENDS  = cross/libtorrent cross/$(SPK_NAME)
WHEELS = characteristic chardet pyasn1-modules python_libtorrent pyxdg Mako service-identity
SPK_DEPENDS = "python>=2.7.6-8"

REQUIRED_DSM = 5.0
UNSUPPORTED_ARCHS = $(PPC_ARCHES)

MAINTAINER = Diaoul
DESCRIPTION = Deluge is a full-featured  BitTorrent client for Linux, OS X, Unix and Windows. It uses libtorrent in its backend and features multiple user-interfaces including: GTK+, web and console. It has been designed using the client server model with a daemon process that handles all the bittorrent activity. The Deluge daemon is able to run on headless machines with the user-interfaces being able to connect remotely from any platform. This package is intended for advanced users.
ADMIN_PORT = 8112
RELOAD_UI = yes
CHANGELOG = Add instruction to wizard on enabling remote access.
DISPLAY_NAME = Deluge

HOMEPAGE = http://deluge-torrent.org
LICENSE  = GPL
HELPURL  = http://dev.deluge-torrent.org/wiki/UserGuide

WIZARDS_DIR      = src/wizard/
INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = deluge_extra_install


include ../../mk/spksrc.spk.mk

.PHONY: deluge_extra_install
deluge_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/core.conf $(STAGING_DIR)/var/core.conf
	install -m 755 -d ${STAGING_DIR}/share/wheelhouse
	install -m 644 ${WORK_DIR}/wheelhouse/* ${STAGING_DIR}/share/wheelhouse/
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

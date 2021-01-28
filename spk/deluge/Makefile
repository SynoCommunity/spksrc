SPK_NAME = deluge
SPK_VERS = 2.0.3
SPK_REV = 13
SPK_ICON = src/deluge.png

BUILD_DEPENDS = cross/python2 cross/setuptools cross/pip_py2 cross/wheel
DEPENDS = cross/$(SPK_NAME)
WHEELS = src/requirements.txt
SPK_DEPENDS = "python>=2.7.18"

REQUIRED_DSM = 5.0
# archs lacking C++11 compiler (88f6281, hi3535 and ppc archs except QorIQ) required by cross/libtorrent
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)

MAINTAINER = Safihre
DESCRIPTION = Deluge is a full-featured BitTorrent client for Linux, OS X, Unix and Windows. It uses libtorrent in its backend and features multiple user-interfaces including: GTK+, web and console. It has been designed using the client server model with a daemon process that handles all the bittorrent activity. The Deluge daemon is able to run on headless machines with the user-interfaces being able to connect remotely from any platform. This package is intended for advanced users.
RELOAD_UI = yes
STARTABLE = yes
CHANGELOG = "Update openssl to 1.1."

DISPLAY_NAME = Deluge

HOMEPAGE = https://deluge-torrent.org
LICENSE  = GPL
HELPURL  = https://dev.deluge-torrent.org/wiki/UserGuide

# Custom start-stop script needed due to double-daemon
SSS_SCRIPT= src/dsm-control.sh

WIZARDS_DIR = src/wizard/

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
	install -m 644 src/autoadd.conf $(STAGING_DIR)/var/autoadd.conf

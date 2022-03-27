SPK_NAME = deluge
SPK_VERS = 2.0.5
SPK_REV = 15
SPK_ICON = src/deluge.png

BUILD_DEPENDS = cross/python310 cross/setuptools cross/pip cross/wheel
DEPENDS = cross/libtorrent cross/deluge
#DEPENDS += cross/rencode

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

SPK_DEPENDS = "python310"

REQUIRED_MIN_DSM = 5.0
# archs lacking C++11 compiler (88f6281, hi3535 and ppc archs except QorIQ) required by cross/libtorrent
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(PPC_ARCHS) $(x86_ARCHS)

MAINTAINER = Strangelovian
DESCRIPTION = "Deluge is a cross platform BitTorrent client, based on libtorrent rasterbar. This syno community package runs the deluge deamon \(deluged\), as well as the deluge web daemon \(deluge-web\), which serves the deluge web UI."
STARTABLE = yes
CHANGELOG = "Update to v2.0.5 and Python 3.10"
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

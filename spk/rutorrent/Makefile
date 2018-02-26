SPK_NAME = rutorrent
SPK_VERS = 3.8
SPK_REV = 9
SPK_ICON = src/rutorrent.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox cross/curl cross/procps-ng cross/mediainfo
DEPENDS += cross/rtorrent cross/rutorrent cross/screen cross/unzip

# Changes to Web Station user were applied in 5.0
REQUIRED_DSM = 5.1

MAINTAINER = Safihre
DESCRIPTION = ruTorrent is a front-end for the popular Bittorrent client rTorrent. rTorrent is a BitTorrent client for ncurses, using the libtorrent library. The client and library is written in C++ with emphasis on speed and efficiency, while delivering equivalent features to those found in GUI based clients in an ncurses client.
ADMIN_URL = /rutorrent/
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = ruTorrent
CHANGELOG = "Use DSM 5+6 generic service approach for correct permissions management."

HOMEPAGE   = https://github.com/Novik/ruTorrent
LICENSE    = GPLv3

SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
WIZARDS_DIR      = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web
INSTUNINST_RESTART_SERVICES = apache-web

POST_STRIP_TARGET = rutorrent_extra_install

BUSYBOX_CONFIG = usrmng daemon nice
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: rutorrent_extra_install
rutorrent_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/.rtorrent.rc $(STAGING_DIR)/var/
	install -m 755 -d $(STAGING_DIR)/var/.session
	install -m 775 -d $(STAGING_DIR)/tmp
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config

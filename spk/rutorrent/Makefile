SPK_NAME = rutorrent
SPK_VERS = 3.10
SPK_REV = 10
SPK_ICON = src/rutorrent.png
DSM_UI_DIR = app

# some dependents require C++11 support
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PCC_ARCHS)
# unsupported with cross/rtorrent
UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS)

DEPENDS = cross/busybox cross/curl cross/procps-ng cross/mediainfo cross/rtorrent cross/rutorrent cross/screen cross/unzip
DEPENDS += cross/sox

MAINTAINER = smaarn
DESCRIPTION = ruTorrent is a front-end for the popular Bittorrent client rTorrent. rTorrent is a BitTorrent client for ncurses, using the libtorrent library. The client and library is written in C++ with emphasis on speed and efficiency, while delivering equivalent features to those found in GUI based clients in an ncurses client.
ADMIN_URL = /rutorrent/
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = ruTorrent
CHANGELOG = "1. Update rutorrent to 3.10<br/>2. Update rtorrent to 0.9.8<br/>3. Update openssl to 1.1<br/>4. Fix bug issue no. 4295<br/>5. Move rtorrent configuration file to web volume for direct user access"

HOMEPAGE   = https://github.com/Novik/ruTorrent
LICENSE    = GPLv3

SERVICE_USER = auto

SERVICE_SETUP        = src/service-setup.sh
SERVICE_WIZARD_SHARE = wizard_download_dir

SERVICE_COMMAND  = /var/packages/$(SPK_NAME)/target/bin/rtorrent-daemon
FWPORTS          = src/$(SPK_NAME).sc
CONF_DIR         = src/conf/
WIZARDS_DIR      = src/wizard/

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web
INSTUNINST_RESTART_SERVICES = apache-web

POST_STRIP_TARGET = rutorrent_extra_install

BUSYBOX_CONFIG = usrmng nice procutils
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

SPK_DEPENDS = "python3>=3.7.7:php5.6"

.PHONY: rutorrent_extra_install
rutorrent_extra_install:
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/bin/rtorrent-daemon $(STAGING_DIR)/bin/rtorrent-daemon
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/.rtorrent.rc $(STAGING_DIR)/var/
	install -m 755 -d $(STAGING_DIR)/var/.session
	install -m 775 -d $(STAGING_DIR)/tmp
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/etc/php/conf.d/
	install -m 644 src/etc/php/conf.d/com.synocommunity.rutorrent.ini $(STAGING_DIR)/etc/php/conf.d/com.synocommunity.rutorrent.ini

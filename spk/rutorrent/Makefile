SPK_NAME = rutorrent
SPK_VERS = 5.2.10
SPK_REV = 22
SPK_ICON = src/rutorrent.png

PYTHON_PACKAGE = python312
WHEELS = src/requirements-pure.txt

# libtorrent-rakshasa requires C++14 support
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k
# SRM is not supported due lacking webstation, php and apache packages
REQUIRED_MIN_SRM = 3.0

MAINTAINER = SynoCommunity
DESCRIPTION = ruTorrent is a front-end for the popular Bittorrent client rTorrent. rTorrent is a BitTorrent client for ncurses, using the libtorrent library. The client and library is written in C++ with emphasis on speed and efficiency, while delivering equivalent features to those found in GUI based clients in an ncurses client.
DISPLAY_NAME = ruTorrent
CHANGELOG = "1. Upgrade ruTorrent to v5.2.10, rtorrent/libtorrent to v0.15.7. <br/>2. Improve stability and reduce package size."

HOMEPAGE = https://github.com/Novik/ruTorrent
LICENSE = GPLv3

WIZARDS_TEMPLATES_DIR = src/wizard_templates
SERVICE_WIZARD_SHARENAME = wizard_data_share

SYSTEM_GROUP = http

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8050
SERVICE_PORT_TITLE = ruTorrent RPC

ADMIN_URL = /rutorrent/

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config

# pgrep commandline tool (used by _tasks plugin) see #4234
DEPENDS += cross/procps-ng

# include bin/curl from cross/curl
DEPENDS += cross/curl
export CURL_INCLUDE_EXECUTABLE=1

# Remaining dependencies
DEPENDS += cross/dumptorrent cross/rtorrent cross/rutorrent cross/sox cross/unzip

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.2),1)
# Default to PHP 8.2 on DSM 7.2+ (PHP 8.0 not supported)
SPK_DEPENDS = "WebStation:PHP8.2:Apache2.4:${PYTHON_PACKAGE}:mediainfo"
CONF_DIR = src/conf_72
else
# Default to PHP 8.0 on DSM 7.0/7.1
SPK_DEPENDS = "WebStation:PHP8.0:Apache2.4:${PYTHON_PACKAGE}:mediainfo"
OS_MAX_VER = 7.1-59999
CONF_DIR = src/conf_7
endif

POST_STRIP_TARGET = rutorrent_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: rutorrent_extra_install
rutorrent_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/.session $(STAGING_DIR)/tmp
	install -m 644 src/rtorrent.rc $(STAGING_DIR)/var/rtorrent.rc

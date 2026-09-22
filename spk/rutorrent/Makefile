SPK_NAME = rutorrent
SPK_VERS = 5.3.14
SPK_REV = 24
SPK_ICON = src/rutorrent.png

# libtorrent-rakshasa and rtorrent mandate C++20: std::ranges (GCC 10+)
# and char8_t (GCC 9+) in sources; configure fails on GCC 8.5 and older
# (verified) and builds green on GCC 12.2
MIN_GCC_VERSION = 10
# DSM 7.2+ platform floor (PHP 8.4, Web Station behavior); the compiler
# floor above excludes older toolchains on its own merits
REQUIRED_MIN_DSM = 7.2
# SRM is not supported due lacking webstation, php and apache packages
REQUIRED_MIN_SRM = 3.0

MAINTAINER = SynoCommunity
DESCRIPTION = ruTorrent is a front-end for the popular Bittorrent client rTorrent. rTorrent is a BitTorrent client for ncurses, using the libtorrent library. The client and library is written in C++ with emphasis on speed and efficiency, while delivering equivalent features to those found in GUI based clients in an ncurses client.
DISPLAY_NAME = ruTorrent
CHANGELOG = "1. Upgrade ruTorrent to v5.3.14 (XMLRPC proxy policy security fix). <br/>2. Upgrade rtorrent/libtorrent to v0.16.23."

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

# PHP 8.4 on DSM 7.2+
TC_OS_MIN_VER = 7.2-60096
SPK_DEPENDS = "WebStation:PHP8.4:Apache2.4:python314:mediainfo"
CONF_DIR = src/conf_72

POST_STRIP_TARGET = rutorrent_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: rutorrent_extra_install
rutorrent_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/.session $(STAGING_DIR)/tmp
	install -m 644 src/rtorrent.rc $(STAGING_DIR)/var/rtorrent.rc
	install -m 755 -d $(STAGING_DIR)/share/wheelhouse
	install -m 644 src/requirements.txt $(STAGING_DIR)/share/wheelhouse/requirements.txt

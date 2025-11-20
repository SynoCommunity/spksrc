SPK_NAME = rutorrent
SPK_VERS = 5.1.12
SPK_REV = 18
SPK_ICON = src/rutorrent.png
DSM_UI_DIR = app

MAINTAINER = smaarn
DESCRIPTION = ruTorrent is a front-end for the popular Bittorrent client rTorrent. rTorrent is a BitTorrent client for ncurses, using the libtorrent library. The client and library is written in C++ with emphasis on speed and efficiency, while delivering equivalent features to those found in GUI based clients in an ncurses client.
DISPLAY_NAME = ruTorrent
CHANGELOG = "1. Upgrade rutorrent to 5.1.12. <br/>2. Update rtorrent to v0.10.0. <br/>3. Update libtorrent to v0.14.0. <br/>4. Update screen to v5.0.1. <br/>5. Migrate to Python 3.12."

# libtorrent-rakshasa requires C++14 support
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k
# SRM is not supported due lacking webstation, php and apache packages
REQUIRED_MIN_SRM = 3.0

PYTHON_PACKAGE = python312
SPK_DEPENDS = "WebStation:${PYTHON_PACKAGE}:PHP7.4:Apache2.4"
WHEELS = src/requirements-pure.txt

# Must be done prior to busybox (aarch64)
DEPENDS += cross/openssl3

# pgrep commandline tool (used by _tasks plugin) see #4234
DEPENDS += cross/busybox
export BUSYBOX_CONFIG=procutils

# include bin/curl from cross/curl
DEPENDS += cross/curl
export CURL_INCLUDE_EXECUTABLE=1

# Remaining dependencies
DEPENDS += cross/mediainfo cross/rtorrent cross/rutorrent cross/screen5 cross/sox cross/unzip
DEPENDS += cross/dumptorrent

ADMIN_URL = /rutorrent/
STARTABLE = yes
HOMEPAGE = https://github.com/Novik/ruTorrent
LICENSE = GPLv3

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_WIZARD_SHARE = wizard_download_dir

DSM_UI_CONFIG = src/app/config

# Required environment variables will be injected in service-setup.sh
SERVICE_COMMAND = /var/packages/rutorrent/target/bin/rtorrent-daemon

CONF_DIR = src/conf/
WIZARDS_DIR = $(WORK_DIR)/generated-wizards
WIZARDS = install_uifile upgrade_uifile

POST_STRIP_TARGET = rutorrent_extra_install

SYSTEM_GROUP = http

SERVICE_PORT = 8050
SERVICE_PORT_TITLE = ruTorrent RPC

SUPPORTED_LANGUAGES = fre

include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

wizards: generated-wizards

include ../../mk/spksrc.spk.mk

.PHONY: generated-wizards
generated-wizards:
	@mkdir -p $(WIZARDS_DIR)
	@for template in $(WIZARDS); do \
		for suffix in '' $(patsubst %,_%,$(SUPPORTED_LANGUAGES)) ; do \
			{\
			  	echo "#!/bin/sh";\
				echo "";\
				cat src/wizard_templates/uifile_vars$${suffix} | sed -e 's/\\/\\\\/g' -e 's/\"/\\\"/g' -e 's/^\([^=]*\)=\\"\(.*\)\\"$$/\1="\2"/g';\
				echo "";\
				cat "$(SPKSRC_MK)spksrc.service.installer.functions";\
				echo "";\
				cat src/wizard_templates/shared_uifile_setup.sh;\
				echo "";\
				cat src/wizard_templates/$${template}.sh;\
			}>$(WIZARDS_DIR)/$${template}$${suffix}.sh;\
		done;\
	done


.PHONY: rutorrent_extra_install
rutorrent_extra_install:
	install -m 755 -d $(STAGING_DIR)/bin $(STAGING_DIR)/var/.session $(STAGING_DIR)/tmp
	install -m 755 src/bin/rtorrent-daemon $(STAGING_DIR)/bin/rtorrent-daemon
	install -m 644 src/rtorrent.rc $(STAGING_DIR)/var/rtorrent.rc

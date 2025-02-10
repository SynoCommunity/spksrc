SPK_NAME = rutorrent
SPK_VERS = 4.3.7
SPK_REV = 17
SPK_ICON = src/rutorrent.png
DSM_UI_DIR = app

MAINTAINER = smaarn
DESCRIPTION = ruTorrent is a front-end for the popular Bittorrent client rTorrent. rTorrent is a BitTorrent client for ncurses, using the libtorrent library. The client and library is written in C++ with emphasis on speed and efficiency, while delivering equivalent features to those found in GUI based clients in an ncurses client.
DISPLAY_NAME = ruTorrent
CHANGELOG = "1. Upgrade rutorrent to 4.3.7"

# newer libtorrent-rakshasa requires C++14 support
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

SPK_DEPENDS = "WebStation:python311:PHP7.4:Apache2.4"
WHEELS = src/requirements-pure.txt

# Must be done prior to busybox (aarch64)
DEPENDS += cross/openssl3

DEPENDS += cross/busybox
export BUSYBOX_CONFIG=procutils

# include bin/curl from cross/curl
DEPENDS += cross/curl
export CURL_INCLUDE_EXECUTABLE=1

# Remaining dependencies
DEPENDS += cross/mediainfo cross/rtorrent cross/rutorrent cross/screen cross/sox cross/unzip

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

FWPORTS = src/rutorrent.sc
CONF_DIR = src/conf/
WIZARDS_DIR = $(WORK_DIR)/generated-wizards
WIZARDS = install_uifile upgrade_uifile

POST_STRIP_TARGET = rutorrent_extra_install

SYSTEM_GROUP = http

SERVICE_PORT = 8050
SERVICE_PORT_TITLE = rutorrent RPC

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
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/bin/rtorrent-daemon $(STAGING_DIR)/bin/rtorrent-daemon
	install -m 755 -d $(STAGING_DIR)/var/.session
	install -m 644 src/rtorrent.rc $(STAGING_DIR)/var/rtorrent.rc
	install -m 775 -d $(STAGING_DIR)/tmp

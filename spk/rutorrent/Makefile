SPK_NAME = rutorrent
SPK_VERS = 4.1.5
SPK_REV = 16
SPK_ICON = src/rutorrent.png
DSM_UI_DIR = app

SPK_DEPENDS = "WebStation:python311:PHP7.4:Apache2.4"
WHEELS = src/requirements-pure.txt

DEPENDS = cross/busybox cross/curl cross/mediainfo cross/rtorrent cross/rutorrent cross/screen cross/unzip
DEPENDS += cross/sox

BUSYBOX_CONFIG = procutils

include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

ifeq ($(call version_lt, $(TCVERSION), 7.0),1)
BUSYBOX_CONFIG += usrmng nice
endif

# include bin/curl from cross/curl
export CURL_INCLUDE_EXECUTABLE=1

MAINTAINER = smaarn
DESCRIPTION = ruTorrent is a front-end for the popular Bittorrent client rTorrent. rTorrent is a BitTorrent client for ncurses, using the libtorrent library. The client and library is written in C++ with emphasis on speed and efficiency, while delivering equivalent features to those found in GUI based clients in an ncurses client.
ADMIN_URL = /rutorrent/
STARTABLE = yes
DISPLAY_NAME = ruTorrent
CHANGELOG = "<ol><li>Upgrade rutorrent to 4.1.5</li><li>Update to Python 3.11</li><li>Update to PHP 7.4</li><li>Remove tools from procps-ng</li><li>Fix support of DSM 7.</li><li>Fix torrent creation wizard (\#5288)</li><li>Add service port declarations</li><li>Migrate to OpenSSL 3.1.2</li></ol>"

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

ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

# some dependents require C++11 support
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)
# unsupported with cross/rtorrent
UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS)

SYSTEM_GROUP = http

SERVICE_PORT = 8050
SERVICE_PORT_TITLE = rutorrent RPC

SUPPORTED_LANGUAGES = fre

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

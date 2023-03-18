SPK_NAME = rutorrent
SPK_VERS = 3.10
SPK_REV = 14
SPK_ICON = src/rutorrent.png
DSM_UI_DIR = app

SPK_DEPENDS = "WebStation:python310:PHP7.4:Apache2.4"
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
CHANGELOG = "<ol><li>Remove outdated resources</li><li>Fix missing dependency declaration on Apache 2.4</li><li>Fixed invalid handling of volume customization upon installation</li><li>Fix handling of watch directory by creating it if it does not exist.</li></ol>"

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

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web
INSTUNINST_RESTART_SERVICES = apache-web

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

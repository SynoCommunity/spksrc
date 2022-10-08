SPK_NAME = rutorrent
SPK_VERS = 3.10
SPK_REV = 13
SPK_ICON = src/rutorrent.png
DSM_UI_DIR = app

SPK_DEPENDS = "python310:PHP7.2"
WHEELS = src/requirements-pure.txt

DEPENDS = cross/curl 
DEPENDS += cross/busybox
DEPENDS += cross/mediainfo 
DEPENDS += cross/rtorrent 
DEPENDS += cross/rutorrent 
DEPENDS += cross/screen 
DEPENDS += cross/sox
DEPENDS += cross/unzip

BUSYBOX_CONFIG = procutils

include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

ifeq ($(call version_lt, $(TCVERSION), 7.0),1)
BUSYBOX_CONFIG += usrmng nice
endif

ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

# include bin/curl from cross/curl
export CURL_INCLUDE_EXECUTABLE=1

MAINTAINER = smaarn
DESCRIPTION = ruTorrent is a front-end for the popular Bittorrent client rTorrent. rTorrent is a BitTorrent client for ncurses, using the libtorrent library. The client and library is written in C++ with emphasis on speed and efficiency, while delivering equivalent features to those found in GUI based clients in an ncurses client.
ADMIN_URL = /rutorrent/
STARTABLE = yes
DISPLAY_NAME = ruTorrent
CHANGELOG = "<ul><li>Fix support of DSM 7.</li><li>Update curl to 7.84.0</li></ul>"

HOMEPAGE = https://github.com/Novik/ruTorrent
LICENSE = GPLv3

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_WIZARD_SHARE = wizard_download_dir

SERVICE_COMMAND = /var/packages/rutorrent/target/bin/rtorrent-daemon
FWPORTS = src/rutorrent.sc
CONF_DIR = src/conf/
WIZARD_TEMPLATES_DIR = src/wizard_templates
WIZARDS_DIR = $(WORK_DIR)/wizards

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web
INSTUNINST_RESTART_SERVICES = apache-web

POST_STRIP_TARGET = rutorrent_extra_install

# some dependents require C++11 support
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)
# unsupported with cross/rtorrent
UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS)

SYSTEM_GROUP = http

ICON_DIR = $(STAGING_DIR)/$(DSM_UI_DIR)/images

INSTALL_WIZARD_TEMPLATES = base_install_uifile
ifeq ($(call version_lt, $(TCVERSION), 7.0),1)
INSTALL_WIZARD_TEMPLATES += additional-configurations
INSTALL_WIZARD_TEMPLATES += dsm-permissions
endif
UPGRADE_WIZARD_TEMPLATES =

SUPPORTED_LANGUAGES = fre

define generate_wizard
	for suffix in '' $(patsubst %,_%,$(SUPPORTED_LANGUAGES)) ; do \
	    jq -s "[.[][]]" $$(for template in $(patsubst %,"%",$(1)) ; do echo "$(WIZARD_TEMPLATES_DIR)/$${template}$${suffix}.json "; done)>"$(2)$${suffix}"; \
	done
endef

.PHONY: generated-wizards
generated-wizards:
	@mkdir -p $(WIZARDS_DIR)
ifneq ($(strip $(INSTALL_WIZARD_TEMPLATES)),)
	@$(call generate_wizard,$(INSTALL_WIZARD_TEMPLATES),$(WIZARDS_DIR)/install_uifile)
endif
ifneq ($(strip $(UPGRADE_WIZARD_TEMPLATES)),)
	@$(call generate_wizard,$(UPGRADE_WIZARD_TEMPLATES),$(WIZARDS_DIR)/upgrade_uifile)
endif

wizards: generated-wizards

include ../../mk/spksrc.spk.mk

.PHONY: rutorrent_extra_install
rutorrent_extra_install:
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/bin/rtorrent-daemon $(STAGING_DIR)/bin/rtorrent-daemon
	install -m 755 -d $(STAGING_DIR)/var/.session
	install -m 644 src/rtorrent.rc $(STAGING_DIR)/var/rtorrent.rc
	install -m 775 -d $(STAGING_DIR)/tmp
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
ifeq ($(call version_lt, $(TCVERSION), 7.0),1)
	install -m 755 -d $(STAGING_DIR)/etc/php/conf.d/
	install -m 644 src/etc/php/conf.d/com.synocommunity.rutorrent.ini $(STAGING_DIR)/etc/php/conf.d/com.synocommunity.rutorrent.ini
endif

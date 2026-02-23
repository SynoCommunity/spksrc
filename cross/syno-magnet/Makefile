PKG_NAME = syno-magnet
PKG_VERS = 1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/neykov/syno-magnet/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/neykov/syno-magnet
COMMENT  = Download Station Magnet Handler. Register Download Station as the application to download magnet links from your browser. No plugins required.
LICENSE  = Apache 2.0

INSTALL_TARGET = syno-magnet_install

# defined to app by default in spksrc.service.mk
DSM_UI_DIR := $(or $(DSM_UI_DIR),app)

# exported from spk/syno-magnet
DISPLAY_NAME := $(or $(DISPLAY_NAME),Download Station Magnet)
DESCRIPTION := $(or $(DESCRIPTION),$(COMMENT))
SERVICE_TYPE := $(or $(SERVICE_TYPE),legacy)
SERVICE_URL := $(or $(SERVICE_URL),/webman/3rdparty/syno-magnet/index.html)
SERVICE_PORT_ALL_USERS := $(or $(SERVICE_PORT_ALL_USERS),true)

DESC=$(shell echo ${DESCRIPTION} | sed -e 's/\\//g' -e 's/"/\\"/g')

include ../../mk/spksrc.install-resources.mk

# Override because we need type "legacy" and no port, protocol, ...
DESC=$(shell echo ${DESCRIPTION} | sed -e 's/\\//g' -e 's/"/\\"/g')
$(WORK_DIR)/config:
	$(create_target_dir)
	@echo '{}' | jq --arg name "${DISPLAY_NAME}" \
	                --arg desc "${DESC}" \
	                --arg id "com.synocommunity.packages.SynoMagnet" \
	                --arg icon "images/${PKG_NAME}-{0}.png" \
	                --arg type "${SERVICE_TYPE}" \
	                --arg url "${SERVICE_URL}" \
	                --argjson allUsers "${SERVICE_PORT_ALL_USERS}" \
	                '{".url":{($$id):{"title":$$name, "desc":$$desc, "icon":$$icon, "type":$$type, "url":$$url, "allUsers":$$allUsers}}}' > $@

.PHONY: syno-magnet_install
syno-magnet_install: $(WORK_DIR)/config
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/$(DSM_UI_DIR)
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/LICENSE $(STAGING_INSTALL_PREFIX)/$(DSM_UI_DIR)
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/index.html $(STAGING_INSTALL_PREFIX)/$(DSM_UI_DIR)
	install -m 644 $(or $(wildcard $(WORK_DIR)/config),$(WORK_DIR)/$(PKG_DIR)/config) $(STAGING_INSTALL_PREFIX)/$(DSM_UI_DIR)

SPK_NAME = syno-magnet
SPK_VERS = 1.0
SPK_REV = 4    # unreleased - refactored to use cross/syno-magnet
SPK_ICON = src/magnet.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = neykov
DESCRIPTION = Download Station Magnet Handler. Register Download Station as the application to download magnet links from your browser. No plugins required.
DISPLAY_NAME = Download Station Magnet
CHANGELOG = "Initial Version"

HOMEPAGE = https://github.com/neykov/syno-magnet
LICENSE = Apache 2.0

DSM_UI_DIR = app
export DSM_UI_DIR
export DESCRIPTION
export DISPLAY_NAME

# Pure web package, make sure ARCH is noarch
override ARCH=noarch

STARTABLE  = no
SERVICE_TYPE = legacy
SERVICE_URL = /webman/3rdparty/syno-magnet/index.html
SERVICE_PORT_ALL_USERS = true

POST_STRIP_TARGET = syno-magnet_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: syno-magnet_extra_install
syno-magnet_extra_install:
	install -m 755 -d $(STAGING_DIR)/$(DSM_UI_DIR)
	install -m 644 $(STAGING_INSTALL_PREFIX)/$(DSM_UI_DIR)/LICENSE $(STAGING_DIR)/$(DSM_UI_DIR)
	install -m 755 $(STAGING_INSTALL_PREFIX)/$(DSM_UI_DIR)/index.html $(STAGING_DIR)/$(DSM_UI_DIR)
	install -m 644 $(STAGING_INSTALL_PREFIX)/$(DSM_UI_DIR)/config $(STAGING_DIR)/$(DSM_UI_DIR)

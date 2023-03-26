SPK_NAME = owncloud
SPK_VERS = 10.12
SPK_REV = 9
SPK_ICON = src/owncloud.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)
SPK_DEPENDS = "WebStation:PHP7.4:Apache2.4"

REQUIRED_MIN_DSM = 6.0

MAINTAINER = ymartin59
DESCRIPTION = ownCloud is a personal cloud which runs on your own server and gives you freedom and control over your own data.
CHANGELOG = "1. Update ownCloud to 10.12.<br/>2. Use faster SQLite database.<br/>3. Use shared folder for data directory."
DISPLAY_NAME = ownCloud
HOMEPAGE = https://owncloud.org/
LICENSE = AGPL

STARTABLE = yes
SERVICE_USER = auto
SERVICE_WIZARD_SHARE = wizard_data_share
USE_DATA_SHARE_WORKER = yes
SERVICE_SETUP = src/service-setup.sh

SYSTEM_GROUP = http

# Admin link for in DSM UI
ADMIN_URL = /owncloud/
ADMIN_PROTOCOL = https

CONF_DIR = src/conf/
WIZARDS_DIR = src/wizard/

DSM_UI_CONFIG = src/app/config

POST_STRIP_TARGET = owncloud_extra_install

# TMPDIR is used for owncloud built in backup and update
USE_ALTERNATE_TMPDIR = 1

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: owncloud_extra_install
owncloud_extra_install:
	install -m 755 -d $(STAGING_DIR)/app -d $(STAGING_DIR)/bin -d $(STAGING_DIR)/web
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/bin/owncloud-daemon $(STAGING_DIR)/bin/owncloud-daemon
	install -m 644 src/web/owncloud.conf $(STAGING_DIR)/web/owncloud.conf
	install -m 644 src/web/owncloud.json $(STAGING_DIR)/web/owncloud.json

SPK_NAME = owncloud
SPK_VERS = 10.11
SPK_REV = 9
SPK_ICON = src/owncloud.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)
SPK_DEPENDS = "WebStation:PHP7.4:Apache2.4"

REQUIRED_MIN_DSM = 6.0

MAINTAINER = ymartin59
DESCRIPTION = ownCloud is a personal cloud which runs on your own server and gives you freedom and control over your own data.
CHANGELOG = "1. Update ownCloud to 10.11.<br/>2. Use faster SQLite database."
DISPLAY_NAME = ownCloud
HOMEPAGE = https://owncloud.org/
LICENSE = AGPL

STARTABLE = yes
SERVICE_USER = auto
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

include ../../mk/spksrc.spk.mk

.PHONY: owncloud_extra_install
owncloud_extra_install:
	install -m 755 -d $(STAGING_DIR)/app -d $(STAGING_DIR)/bin
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/bin/owncloud-daemon $(STAGING_DIR)/bin/owncloud-daemon

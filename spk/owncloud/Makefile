SPK_NAME = owncloud
SPK_VERS = 10.13.2
SPK_REV = 12
SPK_ICON = src/owncloud.png

DEPENDS = cross/owncloud
# Pure PHP package, make sure ARCH is not defined
override ARCH=

REQUIRED_MIN_DSM = 6.0

include ../../mk/spksrc.common.mk
# only for DSM 7 we have dedicated dependencies (must match the configuration in conf/resource)
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
SPK_DEPENDS = WebStation:PHP7.4:Apache2.4
else
# on DSM 6 the default web server and PHP version are used
SPK_DEPENDS = WebStation
endif

MAINTAINER = ymartin59
DESCRIPTION = ownCloud is a personal cloud which runs on your own server and gives you freedom and control over your own data.
DISPLAY_NAME = ownCloud
CHANGELOG = "1. Update ownCloud to 10.13.2.<br/>2. Use new shared folder handling.<br/>3. Package maintenance optimisation."
HOMEPAGE = https://owncloud.org/

LICENSE = AGPL

WIZARDS_TEMPLATES_DIR = src/wizard_templates/
SERVICE_WIZARD_SHARENAME = wizard_data_share
USE_DATA_SHARE_WORKER = yes

SYSTEM_GROUP = http

# Admin link for in DSM UI
ADMIN_URL = /owncloud/
ADMIN_PROTOCOL = https

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config
CONF_DIR = src/conf/

SERVICE_SETUP = src/service-setup.sh
STARTABLE = no

# TMPDIR is used for owncloud built in backup and update
USE_ALTERNATE_TMPDIR = 1

POST_STRIP_TARGET = owncloud_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: owncloud_extra_install
owncloud_extra_install:
	install -m 755 -d $(STAGING_DIR)/bin -d $(STAGING_DIR)/web
	install -m 644 src/web/owncloud.conf $(STAGING_DIR)/web/owncloud.conf
	install -m 644 src/web/owncloud.json $(STAGING_DIR)/web/owncloud.json

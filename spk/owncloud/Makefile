SPK_NAME = owncloud
SPK_VERS = 10.15.0
SPK_REV = 20
SPK_ICON = src/owncloud.png

DEPENDS = cross/owncloud
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = WebStation:PHP7.4:MariaDB10:Apache2.4:redis

MAINTAINER = SynoCommunity
DESCRIPTION = ownCloud is a personal cloud which runs on your own server and gives you freedom and control over your own data.
DISPLAY_NAME = ownCloud
CHANGELOG = "1. Update ownCloud to 10.15.0.<br/>2. Use recommended MariaDB database.<br/>3. Optimise initial ownCloud setup.<br/>4. Various script fixes and refinements."
HOMEPAGE = https://owncloud.com/

LICENSE = AGPLv3
LICENSE_FILE = $(WORK_DIR)/owncloud/COPYING

WIZARDS_TEMPLATES_DIR = src/wizard_templates
SERVICE_WIZARD_SHARENAME = wizard_data_share

SYSTEM_GROUP = http

# Admin link for in DSM UI
ADMIN_URL = /owncloud/
ADMIN_PROTOCOL = https

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config
CONF_DIR = src/conf/

include ../../mk/spksrc.common.mk

# Alternate conf dir for DSM 6
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
CONF_DIR = src/conf_6/
endif

SERVICE_SETUP = src/service-setup.sh
STARTABLE = no

# TMPDIR is used for owncloud built in backup and update
USE_ALTERNATE_TMPDIR = 1

POST_STRIP_TARGET = owncloud_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: owncloud_extra_install
owncloud_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/web/owncloud.conf $(STAGING_DIR)/web/owncloud.conf
	install -m 644 src/web/owncloud.json $(STAGING_DIR)/web/owncloud.json

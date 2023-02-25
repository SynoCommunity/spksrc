SPK_NAME = owncloud
SPK_VERS = 10.11
SPK_REV = 9
SPK_ICON = src/owncloud.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = ymartin59
DESCRIPTION = ownCloud is a personal cloud which runs on your own server and gives you freedom and control over your own data.
ADMIN_URL = /owncloud/
DISPLAY_NAME = ownCloud
CHANGELOG = "1. Update ownCloud to 10.11."

HOMEPAGE   = https://owncloud.org/
LICENSE    = AGPL

REQUIRED_MIN_DSM = 5.0

WIZARDS_DIR = src/wizard/
CONF_DIR = src/conf/

SERVICE_SETUP = src/service-setup.sh
SERVICE_COMMAND = $(INSTALL_PREFIX)/bin/owncloud-daemon

SPK_DEPENDS = "WebStation:MariaDB10:PHP7.4:Apache2.4"
INSTALL_DEP_SERVICES = apache-web mysql
START_DEP_SERVICES = apache-web mysql
INSTUNINST_RESTART_SERVICES = apache-web
SYSTEM_GROUP = http

POST_STRIP_TARGET = owncloud_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: owncloud_extra_install
owncloud_extra_install:
	install -m 755 -d $(STAGING_DIR)/app -d $(STAGING_DIR)/bin
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/bin/owncloud-daemon $(STAGING_DIR)/bin/owncloud-daemon
	install -m 755 src/bin/owncloud.sh $(STAGING_DIR)/bin/owncloud.sh

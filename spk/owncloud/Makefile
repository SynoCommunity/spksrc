SPK_NAME = owncloud
SPK_VERS = 8.1.12
SPK_REV = 8
SPK_ICON = src/owncloud.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox cross/$(SPK_NAME)

MAINTAINER = ymartin59
DESCRIPTION = ownCloud is a personal cloud which runs on your own server and gives you freedom and control over your own data.
ADMIN_URL = /owncloud/
RELOAD_UI = yes
DISPLAY_NAME = ownCloud
CHANGELOG = "1. Update ownCloud to 8.1.12"

HOMEPAGE   = http://owncloud.org/
LICENSE    = AGPL

REQUIRED_DSM = 5.0

WIZARDS_DIR = src/wizard/
CONF_DIR = src/conf/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web mysql
START_DEP_SERVICES = apache-web mysql
INSTUNINST_RESTART_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = owncloud_extra_install

BUSYBOX_CONFIG = daemon nice
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: owncloud_extra_install
owncloud_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 src/owncloud.sh $(STAGING_DIR)/bin/
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/autoconfig.php $(STAGING_DIR)/share/$(SPK_NAME)/config/autoconfig.php

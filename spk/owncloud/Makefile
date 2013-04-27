SPK_NAME = owncloud
SPK_VERS = 5.0.5
SPK_REV = 1
SPK_ICON = src/owncloud.png
DSM_UI_DIR = app

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = ownCloud is a personal cloud which runs on your own server and gives you freedom and control over your own data.
ADMIN_URL = /owncloud/
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = ownCloud

HOMEPAGE   = http://owncloud.org/
LICENSE    = AGPL

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web mysql
START_DEP_SERVICES = apache-web mysql
INSTUNINST_RESTART_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = owncloud_extra_install

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: owncloud_extra_install
owncloud_extra_install: 
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/autoconfig.php $(STAGING_DIR)/share/$(SPK_NAME)/config/autoconfig.php
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

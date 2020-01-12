SPK_NAME = nextcloud
SPK_VERS = 17.0.2
SPK_REV = 1
SPK_ICON = src/nextcloud.png
DSM_UI_DIR = app

DEPENDS  = cross/$(SPK_NAME)
#cross/busybox cross/$(SPK_NAME)

MAINTAINER = DigitalBox98
DESCRIPTION = Nextcloud puts your data at your fingertips, under your control. Store your documents, calendar, contacts and photos on a server at home, at one of our providers or in a data center you trust.
ADMIN_URL = /nextcloud/
RELOAD_UI = yes
DISPLAY_NAME = NextCloud

HOMEPAGE   = https://nextcloud.com
LICENSE    = AGPLv3

REQUIRED_DSM = 5.0

BETA = 1

WIZARDS_DIR = WIZARD_UIFILES/
#CONF_DIR = src/conf/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web 
START_DEP_SERVICES = apache-web 
INSTUNINST_RESTART_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

#.PHONY: owncloud_extra_install
#owncloud_extra_install:
#	install -m 755 -d $(STAGING_DIR)/var
#	install -m 755 src/owncloud.sh $(STAGING_DIR)/bin/
#	install -m 755 -d $(STAGING_DIR)/app
#	install -m 644 src/app/config $(STAGING_DIR)/app/config
#	install -m 644 src/autoconfig.php $(STAGING_DIR)/share/$(SPK_NAME)/config/autoconfig.php

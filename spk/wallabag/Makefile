SPK_NAME = wallabag
SPK_VERS = 2.4.1
SPK_REV = 3
SPK_ICON = src/wallabag.png
DSM_UI_DIR = app
BETA = 1

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = synocommunity
DESCRIPTION = Wallabag is a self hostable application allowing you to save an offline copy of your favorite articles. Click, save, read it when you can. It extracts content so that you can read it when you have time.

include ../../mk/spksrc.common.mk
ADMIN_URL = /wallabag
ifeq ($(call version_lt, $(TCVERSION), 7.0),1)
ADMIN_URL = /wallabag/web/
endif

RELOAD_UI = yes
DISPLAY_NAME = Wallabag
CHANGELOG = "Update to 2.4.1, Update to MariaDB10 and php 7.4 using resouce worker"

HOMEPAGE = https://www.wallabag.org/
LICENSE  = MIT
LICENSE_FILE = $(WORK_DIR)/$(SPK_VERS)/COPYING.md

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT = src/dsm-control.sh
WIZARDS_DIR = src/wizard/

SPK_DEPENDS = "WebStation:MariaDB10>=10.0.30-0005:PHP7.4:Apache2.4"
INSTALL_DEP_SERVICES = apache-web mysql
START_DEP_SERVICES = apache-web mysql
INSTUNINST_RESTART_SERVICES = apache-web
CONF_DIR = src/conf
SYSTEM_GROUP = http

POST_STRIP_TARGET = wallabag_extra_install

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: wallabag_extra_install
wallabag_extra_install:
	install -m 644 src/parameters.yml $(STAGING_DIR)/share/${SPK_NAME}/app/config/parameters.yml
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config

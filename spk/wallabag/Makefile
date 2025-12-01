SPK_NAME = wallabag
SPK_VERS = 2.6.14
SPK_REV = 9
SPK_ICON = src/wallabag.png

DEPENDS  = cross/wallabag
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

# Due to not obvious WebStation handling requirements
REQUIRED_MIN_DSM = 6.0
# SRM is not supported due lacking webstation, php, mariadb and apache packages
REQUIRED_MIN_SRM = 3.0

MAINTAINER = SynoCommunity
DESCRIPTION = Wallabag is a self hostable application allowing you to save an offline copy of your favorite articles. Click, save, read it when you can. It extracts content so that you can read it when you have time.
DISPLAY_NAME = Wallabag
CHANGELOG = "1. Update to v2.6.14.<br/>2. Adjust PHP dependency per DSM version."

HOMEPAGE = https://www.wallabag.org/
LICENSE  = MIT

STARTABLE = no
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

ADMIN_URL = /wallabag

WIZARDS_DIR = src/wizard/
SYSTEM_GROUP = http

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config

include ../../mk/spksrc.common.mk

# Default to PHP 7.4 on DSM 6.x
SPK_DEPENDS = "WebStation:PHP7.4:MariaDB10:Apache2.4"
CONF_DIR = src/conf_6/

ifeq ($(call version_ge, ${TCVERSION}, 7.2),1)
# Use PHP 8.2 on DSM 7.2+ (PHP 8.0 not supported)
SPK_DEPENDS = "WebStation:PHP8.2:MariaDB10:Apache2.4"
CONF_DIR = src/conf_72/
else ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
# Use PHP 8.0 on DSM 7.0/7.1
SPK_DEPENDS = "WebStation:PHP8.0:MariaDB10:Apache2.4"
OS_MAX_VER = 7.1-59999
CONF_DIR = src/conf_7/
endif

POST_STRIP_TARGET = wallabag_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: wallabag_extra_install
wallabag_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/web/index.php $(STAGING_DIR)/web/index.php
	install -m 644 src/web/parameters.yml $(STAGING_DIR)/web/parameters.yml
	install -m 644 src/web/wallabag.conf $(STAGING_DIR)/web/wallabag.conf
	install -m 644 src/web/wallabag.json $(STAGING_DIR)/web/wallabag.json

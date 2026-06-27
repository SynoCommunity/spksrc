SPK_NAME = fengoffice
SPK_VERS = 3.11.13.11
SPK_REV = 9
SPK_ICON = src/fengoffice.png

DEPENDS = cross/fengoffice
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

# Due to not obvious WebStation handling requirements
REQUIRED_MIN_DSM = 6.0
# SRM is not supported due lacking webstation, php, mariadb and apache packages
REQUIRED_MIN_SRM = 3.0

MAINTAINER = SynoCommunity
DESCRIPTION = Feng Office is a Collaboration Platform and Project Management System.
DISPLAY_NAME = Feng Office
CHANGELOG = "1. Update to v3.11.13.11.<br/>2. Use PHP 8.3 on DSM 7.2."

HOMEPAGE = https://www.fengoffice.com/
LICENSE = AGPL

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

ADMIN_URL = /fengoffice/

WIZARDS_DIR = src/wizard/
SYSTEM_GROUP = http

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.2),1)
# Use PHP 8.3 on DSM 7.2
SPK_DEPENDS = "WebStation:PHP8.3:MariaDB10:Apache2.4"
OS_MAX_VER = 7.2-79999
CONF_DIR = src/conf_72/
else ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
# Use PHP 8.0 on DSM 7.0/7.1 and cap at DSM 7.1
SPK_DEPENDS = "WebStation:PHP8.0:MariaDB10:Apache2.4"
OS_MAX_VER = 7.1-59999
CONF_DIR = src/conf_7/
else
# Use PHP 7.4 on DSM 6.x
SPK_DEPENDS = "WebStation:PHP7.4:MariaDB10:Apache2.4"
CONF_DIR = src/conf_6/
endif

ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
POST_STRIP_TARGET = fengoffice_extra_install
endif

include ../../mk/spksrc.spk.mk

.PHONY: fengoffice_extra_install
fengoffice_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/web/fengoffice.conf $(STAGING_DIR)/web/fengoffice.conf
	install -m 644 src/web/fengoffice.json $(STAGING_DIR)/web/fengoffice.json

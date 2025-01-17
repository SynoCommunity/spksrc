SPK_NAME = fengoffice
SPK_VERS = 3.11.4.14
SPK_REV = 5
SPK_ICON = src/fengoffice.png

DEPENDS = cross/fengoffice
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

# Due to not obvious WebStation handling requirements
REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = "WebStation:PHP7.4:MariaDB10:Apache2.4"

MAINTAINER = SynoCommunity
DESCRIPTION = Feng Office is a Collaboration Platform and Project Management System.
DISPLAY_NAME = Feng Office
CHANGELOG = "1. Update to v3.11.4.14."

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
CONF_DIR = src/conf/

include ../../mk/spksrc.common.mk

# Alternate conf dir for DSM 6
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
CONF_DIR = src/conf_6/
endif

POST_STRIP_TARGET = fengoffice_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: fengoffice_extra_install
fengoffice_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/web/fengoffice.conf $(STAGING_DIR)/web/fengoffice.conf
	install -m 644 src/web/fengoffice.json $(STAGING_DIR)/web/fengoffice.json

SPK_NAME = wallabag
SPK_VERS = 2.6.10
SPK_REV = 6
SPK_ICON = src/wallabag.png

DEPENDS  = cross/wallabag
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

# Due to not obvious WebStation handling requirements
REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = "WebStation:PHP7.4:MariaDB10:Apache2.4"

MAINTAINER = SynoCommunity
DESCRIPTION = Wallabag is a self hostable application allowing you to save an offline copy of your favorite articles. Click, save, read it when you can. It extracts content so that you can read it when you have time.
DISPLAY_NAME = Wallabag
CHANGELOG = "1. Update to v2.6.10."

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
CONF_DIR = src/conf/

include ../../mk/spksrc.common.mk

# Alternate conf dir for DSM 6
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
CONF_DIR = src/conf_6/
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

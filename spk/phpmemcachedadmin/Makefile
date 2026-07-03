SPK_NAME = phpmemcachedadmin
SPK_VERS = 1.3.0
SPK_REV = 3
SPK_ICON = src/phpmemcachedadmin.png
DSM_UI_DIR = app

DEPENDS = cross/phpmemcachedadmin
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = "WebStation:PHP7.4:Apache2.4"
# SRM is not supported due lacking webstation, php and apache packages
REQUIRED_MIN_SRM = 3.0

MAINTAINER = SynoCommunity
DESCRIPTION = Graphic stand-alone administration for memcached to monitor and debug purpose.
ADMIN_URL = /phpmemcachedadmin/
DISPLAY_NAME = PHP Memcached Admin
CHANGELOG = "1. Align PHP/WebStation profiles with DSM 6/7 requirements."

HOMEPAGE = https://github.com/elijaa/phpmemcachedadmin
LICENSE  = Apache-2.0

SERVICE_USER = auto
DSM_UI_CONFIG = src/app/config

STARTABLE = no
SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.2),1)
SPK_DEPENDS = "WebStation:PHP8.2:Apache2.4"
CONF_DIR = src/conf_72
else ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
SPK_DEPENDS = "WebStation:PHP8.0:Apache2.4"
OS_MAX_VER = 7.1-59999
CONF_DIR = src/conf_7
endif

ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
POST_STRIP_TARGET = phpmemcachedadmin_extra_install
endif

include ../../mk/spksrc.spk.mk

.PHONY: phpmemcachedadmin_extra_install
phpmemcachedadmin_extra_install:
	@install -m 755 -d $(STAGING_DIR)/web
	@install -m 644 src/web/phpmemcachedadmin.conf $(STAGING_DIR)/web/phpmemcachedadmin.conf
	@install -m 644 src/web/phpmemcachedadmin.json $(STAGING_DIR)/web/phpmemcachedadmin.json

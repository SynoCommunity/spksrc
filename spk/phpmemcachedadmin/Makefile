SPK_NAME = phpmemcachedadmin
SPK_VERS = 1.3.0
SPK_REV = 1
SPK_ICON = src/phpmemcachedadmin.png
DSM_UI_DIR = app

DEPENDS = cross/phpmemcachedadmin
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = WebStation:PHP7.4:Apache2.4

MAINTAINER = SynoCommunity
DESCRIPTION = Graphic stand-alone administration for memcached to monitor and debug purpose.
ADMIN_URL = /phpmemcachedadmin/
DISPLAY_NAME = PHP Memcached Admin
CHANGELOG = "1. Initial release of PHPMemcachedAdmin."

HOMEPAGE = https://github.com/elijaa/phpmemcachedadmin
LICENSE  = Apache-2.0

CONF_DIR = src/conf

SERVICE_USER = auto
DSM_UI_CONFIG = src/app/config

STARTABLE = no
SERVICE_SETUP = src/service-setup.sh

POST_STRIP_TARGET = phpmemcachedadmin_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: phpmemcachedadmin_extra_install
phpmemcachedadmin_extra_install:
	@install -m 755 -d $(STAGING_DIR)/web
	@install -m 644 src/web/phpmemcachedadmin.conf $(STAGING_DIR)/web/phpmemcachedadmin.conf
	@install -m 644 src/web/phpmemcachedadmin.json $(STAGING_DIR)/web/phpmemcachedadmin.json

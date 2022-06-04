SPK_NAME = memcached
SPK_VERS = 1.6.15
SPK_REV = 3
SPK_ICON = src/memcached.png
DSM_UI_DIR = app

DEPENDS = cross/phpmemcachedadmin cross/$(SPK_NAME)

MAINTAINER = Diaoul
DESCRIPTION = Free \& open source, high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load. It comes with phpMemcachedAdmin, a graphic stand-alone administration for memcached to monitor and debug purpose.
ADMIN_URL = /phpMemcachedAdmin/
DISPLAY_NAME = Memcached
CHANGELOG = "1. Update memcached from v1.4.13 to v1.6.15.<br/>2. Add DSM 7 compliance."

HOMEPAGE = https://memcached.org/
LICENSE  = 3-Clause BSD

CONF_DIR = src/conf

SERVICE_USER = auto
SERVICE_PORT = 11211
DSM_UI_CONFIG = src/app/config

# SERVICE_COMMAND is defined in service setup script
STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web

POST_STRIP_TARGET = memcached_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: memcached_extra_install
memcached_extra_install:
	@install -m 755 -d $(STAGING_DIR)/app
	@install -m 644 src/app/config $(STAGING_DIR)/app/config

SPK_NAME = memcached
SPK_VERS = 1.6.9
SPK_REV = 3
SPK_ICON = src/memcached.png
DSM_UI_DIR = app

DEPENDS = cross/phpmemcachedadmin cross/$(SPK_NAME)

MAINTAINER = Diaoul
DESCRIPTION = Free \& open source, high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load. It comes with phpMemcachedAdmin, a graphic stand-alone administration for memcached to monitor and debug purpose.
ADMIN_URL = /phpMemcachedAdmin/
DISPLAY_NAME = Memcached
CHANGELOG = "1. Bump 1.4.13 -> 1.6.9 <br />2. Add DSM 7 compliance"

HOMEPAGE = https://memcached.org/
LICENSE  =

SPK_USER = auto

SERVICE_SETUP    = src/service-setup.sh
# This is a bogus value to ensure that everything is tailored for a SERVICE_COMMAND
# The real value is defined by the setup file
SERVICE_COMMAND  = memcached

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web

POST_STRIP_TARGET = memcached_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: memcached_extra_install
memcached_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config

SPK_NAME = memcached
SPK_VERS = 1.6.20
SPK_REV = 5
SPK_ICON = src/memcached.png
DSM_UI_DIR = app

DEPENDS = cross/phpmemcachedadmin cross/memcached
# Only required for pre DSM 7 versions
OPTIONAL_DEPENDS = cross/busybox

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt, $(TCVERSION), 7.0),1)
DEPENDS += cross/busybox
BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"
endif

MAINTAINER = Diaoul
DESCRIPTION = Free \& open source, high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load. It comes with phpMemcachedAdmin, a graphic stand-alone administration for memcached to monitor and debug purpose.
ADMIN_URL = /phpMemcachedAdmin/
DISPLAY_NAME = Memcached
CHANGELOG = "Update Memcached to v1.6.20"

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

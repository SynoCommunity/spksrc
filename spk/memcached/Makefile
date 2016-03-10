SPK_NAME = memcached
SPK_VERS = 1.4.15
SPK_REV = 2
SPK_ICON = src/memcached.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/phpmemcachedadmin cross/$(SPK_NAME)

MAINTAINER = Diaoul
DESCRIPTION = Free \& open source, high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load. It comes with phpMemcachedAdmin, a graphic stand-alone administration for memcached to monitor and debug purpose.
ADMIN_URL = /phpMemcachedAdmin/
RELOAD_UI = yes
DISPLAY_NAME = Memcached
CHANGELOG = "1. Use 64-bit toolchains for bromolow, cedarview and x86"

HOMEPAGE = http://memcached.org/
LICENSE  =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = memcached_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: memcached_extra_install
memcached_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

SPK_NAME = redis
SPK_VERS = 3.0.5
SPK_REV = 5
SPK_ICON = src/redis.png

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = Diaoul
DESCRIPTION = Redis is an open source, advanced key-value store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets and sorted sets.
RELOAD_UI = yes
DISPLAY_NAME = Redis
CHANGELOG = "Update to 3.0.5"

HOMEPAGE = http://redis.io
LICENSE  = 3-clause BSD

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = redis_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: redis_extra_install
redis_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/redis.conf $(STAGING_DIR)/var/redis.conf

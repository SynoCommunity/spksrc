SPK_NAME = redis
SPK_VERS = 2.6.7
SPK_REV = 1
SPK_ICON = src/redis.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Redis is an open source, advanced key-value store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets and sorted sets.
RELOAD_UI = yes
DISPLAY_NAME = Redis

HOMEPAGE = http://redis.io/
LICENSE  =

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

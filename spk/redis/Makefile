SPK_NAME = redis
SPK_VERS = 5.0.7
SPK_REV = 6
SPK_ICON = src/redis.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = DigitalBox
DESCRIPTION = Redis is an open source, advanced key-value store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets and sorted sets.

RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = redis

CHANGELOG = "Update to 5.0.7"

# PPC_ARCHES except qoriq are not supported anymore
UNSUPPORTED_ARCHS = powerpc ppc824x ppc853x ppc854x

HOMEPAGE = http://redis.io
LICENSE  = 3-clause BSD

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
NO_SERVICE_SHORTCUT = yes

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = redis_extra_install

BUSYBOX_CONFIG = usrmng daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: redis_extra_install
redis_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/redis.conf $(STAGING_DIR)/var/redis.conf

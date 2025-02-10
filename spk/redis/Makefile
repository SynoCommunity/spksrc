SPK_NAME = redis
SPK_VERS = 7.0.15
SPK_REV = 15
SPK_ICON = src/redis.png

DEPENDS = cross/redis

# Unable to determine atomic operations for your platform
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

MAINTAINER = hgy59
DESCRIPTION = Redis is an open source, advanced key-value store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets and sorted sets.

DISPLAY_NAME = redis

CHANGELOG = "Update redis to v7.0.15 (CVE-2023-41056, CVE-2023-45145, CVE-2023-41053, CVE-2022-24834, CVE-2023-36824 and other fixes)."

HOMEPAGE = https://redis.io
LICENSE  = 3-clause BSD

WIZARDS_DIR = src/wizard/

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 6379
SERVICE_PORT_TITLE = redis TCP
NO_SERVICE_SHORTCUT = yes

POST_STRIP_TARGET = redis_extra_install

# add links for tools
SPK_COMMANDS  = bin/redis-benchmark
SPK_COMMANDS += bin/redis-check-aof
SPK_COMMANDS += bin/redis-check-rdb
SPK_COMMANDS += bin/redis-cli
SPK_COMMANDS += bin/redis-sentinel

include ../../mk/spksrc.spk.mk

.PHONY: redis_extra_install
redis_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/redis.conf $(STAGING_DIR)/var/redis.conf
	install -m 644 src/sentinel.conf $(STAGING_DIR)/var/sentinel.conf

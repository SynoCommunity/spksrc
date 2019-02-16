PKG_NAME = redis
PKG_VERS = 3.0.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.redis.io/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://redis.io
COMMENT  = Redis is an open source, advanced key-value store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets and sorted sets.
LICENSE  = BSD

CONFIGURE_TARGET = nop
COMPILE_TARGET = redis_custom_compile

include ../../mk/spksrc.cross-cc.mk

.PHONY: redis_custom_compile
redis_custom_compile:
	$(RUN) $(MAKE) MALLOC=libc DEBUG=

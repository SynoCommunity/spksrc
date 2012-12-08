PKG_NAME = redis
PKG_VERS = 2.6.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://redis.googlecode.com/files
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://redis.io/
COMMENT  = Redis is an open source, advanced key-value store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets and sorted sets.
LICENSE  = 

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile:
	$(RUN) $(MAKE) MALLOC=libc DEBUG=

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install PREFIX=$(STAGING_INSTALL_PREFIX)

PKG_NAME = memcached
PKG_VERS = 1.4.15
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.memcached.org/files
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libevent

HOMEPAGE = http://www.memcached.org/
COMMENT  = Free & open source, high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load.
LICENSE  = BSD

PRE_CONFIGURE_TARGET = myPreConfigure
CONFIGURE_ARGS = ac_cv_c_endian=little
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) autoconf

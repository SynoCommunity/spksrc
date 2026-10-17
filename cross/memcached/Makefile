PKG_NAME = memcached
PKG_VERS = 1.6.45
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.memcached.org/files
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libevent

HOMEPAGE = https://www.memcached.org/
COMMENT  = Free & open source, high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load.
LICENSE  = 3-Clause BSD

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
# EFD_NONBLOCK is not defined (disable use of eventfd)
CONFIGURE_ARGS = ac_cv_func_eventfd=no
endif

include ../../mk/spksrc.cross-cc.mk

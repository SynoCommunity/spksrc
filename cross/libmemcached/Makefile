PKG_NAME = libmemcached
PKG_VERS = 1.0.18
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://launchpad.net/libmemcached/1.0/$(PKG_VERS)/+download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libevent

HOMEPAGE = https://libmemcached.org/libMemcached.html
COMMENT  = libMemcached is an open source C/C++ client library and tools for the memcached server.
LICENSE  = 3-Clause BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --enable-memaslap
CONFIGURE_ARGS += ax_cv_gcc_atomic_builtins=yes
# https://medium.com/swlh/the-complete-guide-to-benchmark-the-performance-of-memcached-on-ubuntu-16-04-71edeaf6e740
CONFIGURE_ARGS += ax_cv_libevent=yes

include ../../mk/spksrc.cross-cc.mk

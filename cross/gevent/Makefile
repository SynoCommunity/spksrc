PKG_NAME = gevent
PKG_VERS = 1.0.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://pypi.python.org/packages/source/g/${PKG_NAME}
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libev cross/c-ares

HOMEPAGE = http://www.gevent.org/
COMMENT  = gevent is a coroutine-based Python networking library that uses greenlet to provide a high-level synchronous API on top of the libev event loop
LICENSE  = MIT

include ../../mk/spksrc.python-wheel.mk

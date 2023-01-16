PKG_NAME = gevent
PKG_VERS = 21.8.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/g/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libev cross/c-ares

HOMEPAGE = https://www.gevent.org
COMMENT  = gevent is a coroutine-based Python networking library that uses greenlet to provide a high-level synchronous API on top of the libev event loop
LICENSE  = MIT

ENV += GEVENTSETUP_EMBED_CARES=FALSE
ENV += GEVENTSETUP_EMBED_LIBEV=FALSE

include ../../mk/spksrc.python-wheel.mk

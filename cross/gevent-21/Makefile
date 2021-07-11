PKG_NAME = gevent
PKG_VERS = 21.1.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/$(PKG_NAME)/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/setuptools
DEPENDS = cross/libev-4.33
DEPENDS += cross/c-ares
DEPENDS += cross/greenlet-1
DEPENDS += cross/zope.event

HOMEPAGE = https://www.gevent.org
COMMENT  = gevent is a coroutine-based Python networking library that uses greenlet to provide a high-level synchronous API on top of the libev event loop
LICENSE  = MIT

ENV += GEVENTSETUP_EMBED_LIBEV=false
ENV += GEVENTSETUP_EMBED_CARES=false

include ../../mk/spksrc.python-wheel.mk

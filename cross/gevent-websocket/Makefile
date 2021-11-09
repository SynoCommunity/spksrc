PKG_NAME = gevent-websocket
PKG_VERS = 0.10.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/g/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gevent

HOMEPAGE = https://www.gitlab.com/noppo/gevent-websocket
COMMENT  = Websocket handler for the gevent pywsgi server, a Python network library
LICENSE  = Copyright 2011-2017 Jeffrey Gelens <jeffrey@noppo.pro>

include ../../mk/spksrc.python-wheel.mk

PKG_NAME = pyzmq
PKG_VERS = 14.5.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://pypi.python.org/packages/source/p/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zeromq cross/libsodium

HOMEPAGE = http://zeromq.org/
COMMENT  = ØMQ (also known as ZeroMQ, 0MQ, or zmq) looks like an embeddable networking library but acts like a concurrency framework.
LICENSE  = LGPL

POST_EXTRACT_TARGET = myPostExtract

include ../../mk/spksrc.python-module.mk

.PHONY: myPostExtract
myPostExtract:
	cp setup.cfg $(WORK_DIR)/$(PKG_DIR)/

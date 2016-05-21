PKG_NAME = pyzmq
PKG_VERS = 15.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/p/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zeromq

HOMEPAGE = http://zeromq.org/
COMMENT  = ØMQ (also known as ZeroMQ, 0MQ, or zmq) looks like an embeddable networking library but acts like a concurrency framework.
LICENSE  = LGPL

POST_EXTRACT_TARGET = myPostExtract

include ../../mk/spksrc.python-module.mk

.PHONY: myPostExtract
myPostExtract:
	cp setup.cfg $(WORK_DIR)/$(PKG_DIR)/

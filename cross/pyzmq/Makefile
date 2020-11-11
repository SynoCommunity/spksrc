PKG_NAME = pyzmq
PKG_VERS = 16.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/p/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libzmq

HOMEPAGE = https://zeromq.org/
COMMENT  = ØMQ (also known as ZeroMQ, 0MQ, or zmq) looks like an embeddable networking library but acts like a concurrency framework.
LICENSE  = LGPL

POST_EXTRACT_TARGET = pyzmq_post_extract

include ../../mk/spksrc.python-wheel.mk

.PHONY: pyzmq_post_extract
pyzmq_post_extract:
	cp src/setup.cfg $(WORK_DIR)/$(PKG_DIR)/

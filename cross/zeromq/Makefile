PKG_NAME = zeromq
PKG_VERS = 4.1.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/$(PKG_NAME)/zeromq4-1/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libsodium

HOMEPAGE = http://zeromq.org
COMMENT  = ØMQ (also known as ZeroMQ, 0MQ, or zmq) looks like an embeddable networking library but acts like a concurrency framework.
LICENSE  = LGPL

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --with-relaxed

include ../../mk/spksrc.cross-cc.mk

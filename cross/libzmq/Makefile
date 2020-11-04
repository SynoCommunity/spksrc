PKG_NAME = libzmq
PKG_VERS = 4.3.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/zeromq/libzmq/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

DEPENDS = cross/libsodium

HOMEPAGE = https://zeromq.org/
COMMENT  = ZeroMQ (also known as ØMQ, 0MQ, or zmq) looks like an embeddable networking library but acts like a concurrency framework. It gives you sockets that carry atomic messages across various transports like in-process, inter-process, TCP, and multicast. 
LICENSE  = GPLv3

include ../../mk/spksrc.cross-cmake.mk

ifeq ($(findstring $(ARCH), 88f6281 ppc853x),$(ARCH))
CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-lrt
CMAKE_ARGS += -DCMAKE_C_FLAGS=-std=gnu99
endif

# Build ZeroMQ with encryption support
CMAKE_ARGS += -DWITH_LIBSODIUM=ON

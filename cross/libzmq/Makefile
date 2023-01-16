PKG_NAME = libzmq
PKG_VERS = 4.3.4
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

# Flags to be added to CMake toolchain file
ifeq ($(findstring $(ARCH), 88f6281 ppc853x),$(ARCH))
ADDITIONAL_CFLAGS += -std=gnu99
ADDITIONAL_CXXFLAGS += -lrt
endif

# Build ZeroMQ with encryption support
CMAKE_ARGS += -DWITH_LIBSODIUM=ON

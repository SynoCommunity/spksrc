PKG_NAME = libzmq
PKG_VERS = 4.3.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/zeromq/libzmq/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

DEPENDS = cross/libsodium

HOMEPAGE = https://zeromq.org/
COMMENT  = ZeroMQ (also known as ØMQ, 0MQ, or zmq) looks like an embeddable networking library but acts like a concurrency framework. It gives you sockets that carry atomic messages across various transports like in-process, inter-process, TCP, and multicast. 
LICENSE  = GPLv3

include ../../mk/spksrc.common.mk

# CMakeLists.txt adds -std=c++11 once the compiler merely ACCEPTS the flag: gcc 4.7 does,
# without implicit noexcept on destructors. Pin it instead -- 4.6 and older already build.
ifeq ($(call version_lt,$(TC_GCC),4.8),1)
ADDITIONAL_CXXFLAGS += -std=gnu++98
endif

include ../../mk/spksrc.cross-cmake.mk

# Flags to be added to CMake toolchain file
ifeq ($(findstring $(ARCH), 88f6281 ppc853x),$(ARCH))
ADDITIONAL_CFLAGS += -std=gnu99
ADDITIONAL_CXXFLAGS += -lrt
endif

# Build ZeroMQ with encryption support
CONFIGURE_ARGS += -DWITH_LIBSODIUM=ON

# Disable benchmarking performance tools
CONFIGURE_ARGS += -DWITH_PERF_TOOL=OFF

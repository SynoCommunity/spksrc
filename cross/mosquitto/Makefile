PKG_NAME = mosquitto
PKG_VERS = 2.1.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://mosquitto.org/files/source
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/c-ares
DEPENDS += cross/openssl3
DEPENDS += cross/cjson
DEPENDS += cross/sqlite

# C++17 required by mosquittopp:
#   CMake Error in lib/cpp/CMakeLists.txt: Target "mosquittopp" requires the
#   language dialect "CXX17"
MIN_GCC_VERSION = 7

HOMEPAGE = https://www.mosquitto.org/
COMMENT  = Eclipse Mosquitto is an open source (EPL/EDL licensed) message broker that implements the MQTT protocol versions 5.0, 3.1.1 and 3.1.
LICENSE  = EPL 1.0 and EDL 1.0

CONFIGURE_ARGS += -DWITH_SRV=ON
CONFIGURE_ARGS += -DDOCUMENTATION=OFF
CONFIGURE_ARGS += -DWITH_TESTS=OFF

# Upstream's src/CMakeLists.txt enables epoll with
# find_path(HAVE_SYS_EPOLL_H sys/epoll.h), but sys/epoll.h is a toolchain header.
# Our CMake toolchain deliberately restricts find_*() to the staging prefix
# (CMAKE_FIND_ROOT_PATH_MODE_INCLUDE = ONLY) for hermetic dependency resolution,
# so the probe never sees the sysroot and the broker silently builds the poll
# backend, which can spin on POLLNVAL for closed descriptors. Every DSM target is
# Linux with epoll, so force the detection (a compiler-based
# check_include_file() would be the correct upstream fix).
CONFIGURE_ARGS += -DHAVE_SYS_EPOLL_H=1

include ../../mk/spksrc.cross-cmake.mk

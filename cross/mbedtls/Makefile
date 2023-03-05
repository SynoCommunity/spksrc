PKG_NAME = mbedtls
PKG_VERS = 2.28.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ARMmbed/mbedtls/archive
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = https://www.trustedfirmware.org/projects/mbed-tls/
COMMENT  = A C library implementing cryptographic primitives, X.509 certificate manipulation and the SSL/TLS and DTLS protocols. Its small code footprint makes it suitable for embedded systems.
LICENSE  = Apache 2.0

CMAKE_ARGS  = -DENABLE_ZLIB_SUPPORT=On
CMAKE_ARGS += -DUSE_SHARED_MBEDTLS_LIBRARY=On
CMAKE_ARGS += -DENABLE_TESTING=Off
CMAKE_ARGS += -DENABLE_PROGRAMS=Off

include ../../mk/spksrc.cross-cmake.mk

# Flags to be added to CMake toolchain file
ifeq ($(call version_lt, ${TC_GCC}, 5)$(call version_ge, ${TC_GCC}, 3),11)
ADDITIONAL_CFLAGS += -std=gnu99
endif

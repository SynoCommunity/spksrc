PKG_NAME = mbedtls
PKG_VERS = 2.28.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ARMmbed/mbedtls/archive
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = https://www.trustedfirmware.org/projects/mbed-tls/
COMMENT  = Mbed TLS implements cryptographic primitives, X.509 certificate manipulation and the SSL/TLS and DTLS protocols. Its small code footprint makes it suitable for embedded systems.
LICENSE  = Apache 2.0

CMAKE_ARGS  = -DENABLE_ZLIB_SUPPORT=ON
CMAKE_ARGS += -DUSE_SHARED_MBEDTLS_LIBRARY=ON
CMAKE_ARGS += -DUSE_STATIC_MBEDTLS_LIBRARY=OFF
CMAKE_ARGS += -DENABLE_TESTING=OFF
CMAKE_ARGS += -DENABLE_PROGRAMS=OFF

include ../../mk/spksrc.cross-cmake.mk

# Flags to be added to CMake toolchain file
ifeq ($(call version_lt, ${TC_GCC}, 5)$(call version_ge, ${TC_GCC}, 3),11)
ADDITIONAL_CFLAGS += -std=gnu99
endif

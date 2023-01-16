PKG_NAME = mbedtls
PKG_VERS = 2.28.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ARMmbed/mbedtls/archive
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://tls.mbed.org
COMMENT  = mbed TLS (formerly known as PolarSSL) makes it trivially easy for developers to include cryptographic and SSL/TLS capabilities in their (embedded) products, facilitating this functionality with a minimal coding footprint.
LICENSE  = Apache 2.0

CMAKE_ARGS = -DUSE_SHARED_MBEDTLS_LIBRARY=On
CMAKE_ARGS += -DENABLE_TESTING=Off
CMAKE_ARGS += -DENABLE_PROGRAMS=Off

include ../../mk/spksrc.cross-cmake.mk

# Flags to be added to CMake toolchain file
ifeq ($(call version_lt, ${TC_GCC}, 5),1)
ADDITIONAL_CFLAGS += -std=gnu99
endif

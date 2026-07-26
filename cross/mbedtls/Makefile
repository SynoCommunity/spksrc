PKG_NAME = mbedtls
PKG_VERS = 3.6.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ARMmbed/mbedtls/archive
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.trustedfirmware.org/projects/mbed-tls/
COMMENT  = Mbed TLS implements cryptographic primitives, X.509 certificate manipulation and the SSL/TLS and DTLS protocols. Its small code footprint makes it suitable for embedded systems.
LICENSE  = Apache 2.0 or GPLv2+

CONFIGURE_ARGS  = -DUSE_SHARED_MBEDTLS_LIBRARY=ON
CONFIGURE_ARGS += -DUSE_STATIC_MBEDTLS_LIBRARY=OFF
CONFIGURE_ARGS += -DENABLE_TESTING=OFF
CONFIGURE_ARGS += -DENABLE_PROGRAMS=OFF

include ../../mk/spksrc.cross-cmake.mk

PKG_NAME = libwebsockets
PKG_VERS = 4.3.7
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/warmcat/libwebsockets/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3

# glibc 2.8 has no eventfd2 flag macros (added in 2.9):
#   lib/plat/unix/unix-pipe.c:37: 'EFD_CLOEXEC' undeclared
MIN_GLIBC_VERSION = 2.9

HOMEPAGE = https://libwebsockets.org/
COMMENT  = Libwebsockets (LWS) is a flexible, lightweight pure C library for implementing modern network protocols easily with a tiny footprint, using a nonblocking event loop.
LICENSE  = MIT

CONFIGURE_ARGS += -DLWS_WITHOUT_TESTAPPS=ON
CONFIGURE_ARGS += -DDISABLE_WERROR=ON
CONFIGURE_ARGS += -DLWS_WITH_STATIC=OFF

# mosquitto needs external poll feature:
# warning "libwebsockets is not compiled with LWS_WITH_EXTERNAL_POLL support. Websocket performance will be unusable." [-Wcpp]
CONFIGURE_ARGS += -DLWS_WITH_EXTERNAL_POLL=ON

include ../../mk/spksrc.cross-cmake.mk

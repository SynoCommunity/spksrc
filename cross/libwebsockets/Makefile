PKG_NAME = libwebsockets
PKG_VERS = 4.3.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/warmcat/libwebsockets/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

# ppc except qoriq
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://libwebsockets.org/
COMMENT  = Libwebsockets (LWS) is a flexible, lightweight pure C library for implementing modern network protocols easily with a tiny footprint, using a nonblocking event loop.
LICENSE  = MIT

CMAKE_USE_TOOLCHAIN_FILE = OFF
CMAKE_ARGS += -DLWS_WITHOUT_TESTAPPS=ON
CMAKE_ARGS += -DDISABLE_WERROR=ON
CMAKE_ARGS += -DLWS_WITH_STATIC=OFF

# mosquitto needs external poll feature:
# warning "libwebsockets is not compiled with LWS_WITH_EXTERNAL_POLL support. Websocket performance will be unusable." [-Wcpp]
CMAKE_ARGS += -DLWS_WITH_EXTERNAL_POLL=ON

include ../../mk/spksrc.cross-cmake.mk

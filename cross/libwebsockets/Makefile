PKG_NAME = libwebsockets
PKG_VERS = 3.2.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/warmcat/libwebsockets/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

# ppc except qoriq
UNSUPPORTED_ARCHS = $(OLD_PCC_ARCHS)

HOMEPAGE = https://libwebsockets.org/
COMMENT  = Libwebsockets (LWS) is a flexible, lightweight pure C library for implementing modern network protocols easily with a tiny footprint, using a nonblocking event loop.
LICENSE  = MIT

include ../../mk/spksrc.cross-cmake.mk

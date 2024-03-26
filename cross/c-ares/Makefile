PKG_NAME = c-ares
PKG_VERS = 1.19.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://c-ares.org/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://c-ares.org/
COMMENT  = c-ares is a C library for asynchronous DNS requests (including name resolves).
LICENSE  = MIT

CMAKE_ARGS += -DCARES_BUILD_TOOLS=OFF

include ../../mk/spksrc.cross-cmake.mk

PKG_NAME = libuv
PKG_VERS = 1.42.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://dist.libuv.org/dist/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

DEPENDS =

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://libuv.org/
COMMENT  = libuv is a multi-platform support library with a focus on asynchronous I/O.
LICENSE  = MIT

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cmake.mk

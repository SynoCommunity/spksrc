PKG_NAME = libuv
PKG_VERS = 1.44.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libuv/libuv/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# fails to build src/unix/async.c
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://libuv.org/
COMMENT  = libuv is a multi-platform support library with a focus on asynchronous I/O.
LICENSE  = MIT

GNU_CONFIGURE = 1

CMAKE_ARGS += -DBUILD_TESTING=OFF

include ../../mk/spksrc.cross-cmake.mk

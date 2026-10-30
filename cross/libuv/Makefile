PKG_NAME = libuv
PKG_VERS = 1.44.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libuv/libuv/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# glibc 2.8 has neither the eventfd2 nor the accept4 flag macros (added in 2.9):
#   src/unix/async.c:210: 'EFD_CLOEXEC' undeclared
#   src/unix/tcp.c:482: 'SOCK_CLOEXEC' undeclared
MIN_GLIBC_VERSION = 2.9

HOMEPAGE = https://libuv.org/
COMMENT  = libuv is a multi-platform support library with a focus on asynchronous I/O.
LICENSE  = MIT

GNU_CONFIGURE = 1

CONFIGURE_ARGS += -DBUILD_TESTING=OFF

include ../../mk/spksrc.cross-cmake.mk

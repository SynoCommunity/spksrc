PKG_NAME = libssh2
PKG_VERS = 1.11.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.libssh2.org/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3

HOMEPAGE = https://www.libssh2.org
COMMENT  = libssh2 is a client-side C library implementing the SSH2 protocol.
LICENSE  = 3-Clause BSD

CMAKE_ARGS += -DBUILD_SHARED_LIBS=ON
CMAKE_ARGS += -DBUILD_STATIC_LIBS=OFF
CMAKE_ARGS += -DBUILD_EXAMPLES=OFF
CMAKE_ARGS += -DBUILD_TESTING=OFF

include ../../mk/spksrc.cross-cmake.mk

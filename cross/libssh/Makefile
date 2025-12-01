PKG_NAME = libssh
PKG_VERS = 0.11.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.libssh.org/files/$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.libssh.org/
COMMENT  = libssh is a multiplatform C library implementing the SSHv2 protocol on client and server side.
LICENSE  = LGPL v2.1

CMAKE_ARGS += -DWITH_EXAMPLES=OFF

include ../../mk/spksrc.cross-cmake.mk

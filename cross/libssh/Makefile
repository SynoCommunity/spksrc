PKG_NAME = libssh
PKG_VERS = 0.11.4
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gitlab.com/libssh/libssh-mirror/-/archive/libssh-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.libssh.org/
COMMENT  = libssh is a multiplatform C library implementing the SSHv2 protocol on client and server side.
LICENSE  = LGPL v2.1

CMAKE_ARGS += -DWITH_EXAMPLES=OFF
POST_EXTRACT_TARGET = libssh_post-extract

include ../../mk/spksrc.cross-cmake.mk

.PHONY: libssh_post-extract
libssh_post-extract:
	@EXTRACTED=$(wildcard $(WORK_DIR)/libssh-mirror-libssh-$(PKG_VERS)-*/); \
	 ln -sf $${EXTRACTED%/} $(WORK_DIR)/$(PKG_DIR)

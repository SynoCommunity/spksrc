PKG_NAME = libssh2
PKG_VERS = 1.9.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.libssh2.org/download/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

HOMEPAGE = https://www.libssh2.org
COMMENT  = libssh2 is a client-side C library implementing the SSH2 protocol.
LICENSE  = https://www.libssh2.org/license.html

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-examples-build

include ../../mk/spksrc.cross-cc.mk

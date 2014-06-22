PKG_NAME = libssh2
PKG_VERS = 1.4.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.libssh2.org/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)


DEPENDS = cross/openssl

HOMEPAGE = http://www.libssh2.org/
COMMENT  = libssh2 is a client-side C library implementing the SSH2 protocol
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-openssl --enable-shared=yes --enable-static=yes

include ../../mk/spksrc.cross-cc.mk


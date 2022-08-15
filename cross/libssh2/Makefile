PKG_NAME = libssh2
PKG_VERS = 1.10.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.libssh2.org/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

HOMEPAGE = https://www.libssh2.org
COMMENT  = libssh2 is a client-side C library implementing the SSH2 protocol.
LICENSE  = 3-Clause BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-examples-build
CONFIGURE_ARGS += --disable-static
# Regarding https://github.com/libssh2/libssh2/issues/230 we can ignore the following warning,
# as we use openssl backend:
# configure: WARNING: secure clearing/zeroing of memory is not supported by the selected crypto backend

ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk

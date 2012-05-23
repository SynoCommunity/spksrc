PKG_NAME = libgcrypt
PKG_VERS = 1.5.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gnupg.org/gcrypt/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libgpg-error

HOMEPAGE = http://directory.fsf.org/wiki/Libgcrypt
COMMENT  = This is a general purpose cryptographic library based on the code from GnuPG
LICENSE  = LGPL

CONFIGURE_ARGS = --with-gpg-error-prefix=$(STAGING_INSTALL_PREFIX)
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk


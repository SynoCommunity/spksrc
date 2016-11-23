PKG_NAME = libgcrypt
PKG_VERS = 1.6.4
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gnupg.org/gcrypt/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libgpg-error

HOMEPAGE = http://directory.fsf.org/wiki/Libgcrypt
COMMENT  = This is a general purpose cryptographic library based on the code from GnuPG
LICENSE  = LGPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

CONFIGURE_ARGS = --with-gpg-error-prefix=$(STAGING_INSTALL_PREFIX) ac_cv_sys_symbol_underscore=no

POST_INSTALL_TARGET = myPostInstall

.PHONY: myPostInstall
myPostInstall:
	sed -i -e 's|^prefix=$(INSTALL_PREFIX)$$|prefix=$(STAGING_INSTALL_PREFIX)|' $(STAGING_INSTALL_PREFIX)/bin/libgcrypt-config

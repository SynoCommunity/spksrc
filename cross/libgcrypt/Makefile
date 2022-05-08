PKG_NAME = libgcrypt
PKG_VERS = 1.8.8
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gnupg.org/ftp/gcrypt/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libgpg-error

HOMEPAGE = https://gnupg.org/related_software/libgcrypt/
COMMENT  = This is a general purpose cryptographic library based on the code from GnuPG.
LICENSE  = LGPLv2.1+

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-gpg-error-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += ac_cv_sys_symbol_underscore=no

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-cc.mk

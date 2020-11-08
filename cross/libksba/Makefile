PKG_NAME = libksba
PKG_VERS = 1.4.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gnupg.org/ftp/gcrypt/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libgpg-error

HOMEPAGE = https://gnupg.org/related_software/libksba/
COMMENT  = Libksba is a library to make the tasks of working with X.509 certificates, CMS data and related objects more easy. 
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-libgpg-error-prefix=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

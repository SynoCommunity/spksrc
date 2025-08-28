PKG_NAME = libassuan
PKG_VERS = 2.5.7
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.gnupg.org/ftp/gcrypt/libassuan
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Versions newer than 2.5.7 are not compatible with gpgme v1.17.1

DEPENDS = cross/libgpg-error

HOMEPAGE = https://www.gnupg.org/related_software/libassuan/ 
COMMENT  = Libassuan is a small library implementing the so-called Assuan protocol. 
LICENSE  = LGPLv2.1+

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-libgpg-error-prefix=$(STAGING_INSTALL_PREFIX)

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-cc.mk

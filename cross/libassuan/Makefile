PKG_NAME = libassuan
PKG_VERS = 2.5.5
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.gnupg.org/ftp/gcrypt/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libgpg-error

HOMEPAGE = https://www.gnupg.org/related_software/libassuan/ 
COMMENT  = Libassuan is a small library implementing the so-called Assuan protocol. 
LICENSE  = LGPLv2.1+

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-libgpg-error-prefix=$(STAGING_INSTALL_PREFIX)

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-cc.mk

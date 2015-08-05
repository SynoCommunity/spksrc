PKG_NAME = libassuan
PKG_VERS = 2.2.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gnupg.org/gcrypt/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libgpg-error

HOMEPAGE = https://www.gnupg.org/related_software/libassuan/ 
COMMENT  = Libassuan is a small library implementing the so-called Assuan protocol. 
LICENSE  = LGPL

PRE_CONFIGURE_TARGET = myPreConfigure
CONFIGURE_ARGS = --with-libgpg-error-prefix=$(STAGING_INSTALL_PREFIX)
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

myPreConfigure:
	$(RUN) ; ./autogen.sh

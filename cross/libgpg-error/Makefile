PKG_NAME = libgpg-error
PKG_VERS = 1.47
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gnupg.org/ftp/gcrypt/libgpg-error
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://gnupg.org/related_software/libgpg-error/
COMMENT  = Libgpg-error is a small library that originally defined common error values for all GnuPG components. 
LICENSE  = LGPLv2.1+

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-install-gpg-error-config
ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-cc.mk

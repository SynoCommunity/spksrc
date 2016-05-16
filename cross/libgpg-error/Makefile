PKG_NAME = libgpg-error
PKG_VERS = 1.21
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gnupg.org/gcrypt/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.gnupg.org/related_software/libgpg-error/
COMMENT  = Libgpg-error is a small library that defines common error values for all GnuPG components
LICENSE  = LGPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(ARM_ARCHES)),$(ARCH))
CONFIGURE_ARGS = --target=arm-unknown-linux-gnueabi --host=arm-unknown-linux-gnueabi
endif
ifeq ($(findstring $(ARCH),ppc853x qoriq),$(ARCH))
CONFIGURE_ARGS = --target=powerpc-unknown-linux-gnu --host=powerpc-unknown-linux-gnu
endif

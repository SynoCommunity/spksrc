PKG_NAME = libgpg-error
PKG_VERS = 1.42
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gnupg.org/ftp/gcrypt/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://gnupg.org/related_software/libgpg-error/
COMMENT  = Libgpg-error is a small library that originally defined common error values for all GnuPG components. 
LICENSE  = LGPLv2.1+

GNU_CONFIGURE = 1

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
# rename aarch64-unknown-linux-gnueabi to aarch64-unknown-linux-gnu
# to match provided syscfg/lock-obj-pub.aarch64-unknown-linux-gnu.h
CONFIGURE_ARGS = --host=aarch64-unknown-linux-gnu
endif

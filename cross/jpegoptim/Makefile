PKG_NAME = jpegoptim
PKG_VERS = 1.4.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/tjko/jpegoptim/archive
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-v$(PKG_VERS)

DEPENDS = cross/libjpeg

HOMEPAGE = https://github.com/tjko/jpegoptim
COMMENT = Utility to optimize/compress JPEG files.
LICENSE = GPLv2

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS = ac_cv_func_utimensat=no
endif

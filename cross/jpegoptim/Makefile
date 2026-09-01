PKG_NAME = jpegoptim
PKG_VERS = 1.5.6
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/tjko/jpegoptim/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libjpeg

HOMEPAGE = https://github.com/tjko/jpegoptim
COMMENT = Utility to optimize/compress JPEG files.
LICENSE = GPLv3

GNU_CONFIGURE = 1
# jpegoptim >= 1.5.6 uses C99 for-loop declarations; gcc < 5 defaults to gnu90
ADDITIONAL_CFLAGS = -O -std=gnu99

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS = ac_cv_func_utimensat=no
endif

PKG_NAME = libimagequant
PKG_VERS = 2.12.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ImageOptim/libimagequant/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
# Set an appropriate filename as release files on github doesn't
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

DEPENDS = 

HOMEPAGE = https://pngquant.org/lib/
COMMENT  = Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images.
LICENSE  = GPLv3

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -O3

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --enable-sse
else
CONFIGURE_ARGS += --disable-sse
endif

include ../../mk/spksrc.cross-cc.mk

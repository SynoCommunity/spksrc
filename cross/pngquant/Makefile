PKG_NAME = pngquant
PKG_VERS = 2.17.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-src.$(PKG_EXT)
PKG_DIST_SITE = http://sources.buildroot.net/pngquant
# Many connection timed out using official source
#PKG_DIST_SITE = https://pngquant.org
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpng cross/libimagequant

HOMEPAGE = https://pngquant.org/
COMMENT  = pngquant is a command-line utility and a library for lossy compression of PNG images.
LICENSE  = GPL

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -O3
CONFIGURE_ARGS = --with-libimagequant

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-sse
else
CONFIGURE_ARGS += --disable-sse
endif

include ../../mk/spksrc.cross-cc.mk

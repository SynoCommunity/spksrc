PKG_NAME = x264
PKG_VERS = 20141218-2245
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-snapshot-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.videolan.org/pub/x264/snapshots/
PKG_DIR = $(PKG_NAME)-snapshot-$(PKG_VERS)

DEPENDS =
GNU_CONFIGURE = 1
HOMEPAGE = http://www.videolan.org/developers/x264.html
COMMENT  = x264 is a free software library and application for encoding video streams into the H.264/MPEG-4 AVC forma
LICENSE  =

CONFIGURE_ARGS = --enable-static --disable-asm --prefix=$(INSTALL_PREFIX)

ifeq ($(findstring $(ARCH), 88f6281),$(ARCH))
ADDITIONAL_CFLAGS = -O0
endif

include ../../mk/spksrc.cross-cc.mk

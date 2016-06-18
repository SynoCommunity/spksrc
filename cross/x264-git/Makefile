PKG_NAME = x264-git
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = 3b70645597bea052d2398005bc723212aeea6875
PKG_DIST_SITE = git://git.videolan.org/x264.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

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

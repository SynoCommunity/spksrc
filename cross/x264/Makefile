PKG_NAME = x264
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = stable
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://git.videolan.org/git/x264.git
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

PRE_DOWNLOAD_TARGET = eraseDownload

include ../../mk/spksrc.cross-cc.mk

.PHONY: eraseDownload
eraseDownload:
	@rm -f $(DISTRIB_DIR)/$(PKG_DIST_FILE)

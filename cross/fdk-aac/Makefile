PKG_NAME = fdk-aac
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = 15b128dd826ba86ee962d86b0b06966a25ed9158
PKG_DIST_SITE = https://github.com/mstorsjo/fdk-aac.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS =
GNU_CONFIGURE = 1
HOMEPAGE = http://www.videolan.org/developers/x264.html
COMMENT  = x264 is a free software library and application for encoding video streams into the H.264/MPEG-4 AVC forma
LICENSE  =

PRE_CONFIGURE_TARGET = myPreConfigure
CONFIGURE_ARGS = --enable-static --disable-shared --prefix=$(INSTALL_PREFIX)

ifeq ($(findstring $(ARCH), 88f6281),$(ARCH))
ADDITIONAL_CFLAGS = -O0
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	@$(RUN) ; ./autogen.sh

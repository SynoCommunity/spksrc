PKG_NAME = Comskip
PKG_VERS = 0.82.010
PKG_EXT = tar.gz
PKG_GIT_HASH = a041945ffa5dc0c53119e732f25e4d23b11ffa9e
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/erikkaashoek/Comskip/archive
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

DEPENDS = cross/argtable
OPTIONAL_DEPENDS = cross/ffmpeg4

HOMEPAGE = https://www.kaashoek.com/comskip
COMMENT  = Commercial detector
LICENSE  = GNU/LGPL

ifeq ($(wildcard $(FFMPEG_DIR)),)
DEPENDS += cross/ffmpeg$(FFMPEG_VERSION)
endif

PRE_CONFIGURE_TARGET = comskip_pre_configure
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: comskip_pre_configure
comskip_pre_configure:
	$(RUN) ; ./autogen.sh

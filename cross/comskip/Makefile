PKG_NAME = Comskip
PKG_VERS = 0.82.010
PKG_EXT = tar.gz
PKG_GIT_HASH = 2ef86841cd84df66fe0e674f300ee49cef6e097a
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/erikkaashoek/Comskip/archive
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

DEPENDS = cross/argtable
OPTIONAL_DEPENDS = cross/ffmpeg5

HOMEPAGE = https://www.kaashoek.com/comskip
COMMENT  = Commercial detector
LICENSE  = GNU/LGPL

PRE_CONFIGURE_TARGET = comskip_pre_configure
GNU_CONFIGURE = 1

ifeq ($(wildcard $(FFMPEG_PACKAGE_ROOT)),)
DEPENDS = cross/ffmpeg5
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: comskip_pre_configure
comskip_pre_configure:
	$(RUN) ; ./autogen.sh

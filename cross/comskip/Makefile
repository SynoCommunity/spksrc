PKG_NAME = Comskip
PKG_VERS = 0.83
PKG_EXT = tar.gz
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_NAME = V$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/erikkaashoek/Comskip/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/argtable
OPTIONAL_DEPENDS = cross/ffmpeg7

HOMEPAGE = https://www.kaashoek.com/comskip
COMMENT  = Commercial detector
LICENSE  = GNU/LGPL

PRE_CONFIGURE_TARGET = comskip_pre_configure
GNU_CONFIGURE = 1

ifeq ($(wildcard $(FFMPEG_PACKAGE_ROOT)),)
DEPENDS = cross/ffmpeg7
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: comskip_pre_configure
comskip_pre_configure:
	$(RUN) ; ./autogen.sh

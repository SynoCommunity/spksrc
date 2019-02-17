PKG_NAME = comskip
PKG_VERS = 0.82.003
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = 6030aa0d3b589161ec96c6c986c48aa826fb9f72
PKG_DIST_SITE = https://github.com/erikkaashoek/Comskip.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/argtable

HOMEPAGE = http://www.kaashoek.com/comskip
COMMENT  = Commercial detector
LICENSE  = GNU/LGPL

ifeq ($(wildcard $(FFMPEG_DIR)),)
DEPENDS += cross/ffmpeg
endif

PRE_CONFIGURE_TARGET = comskip_pre_configure
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: comskip_pre_configure
comskip_pre_configure:
	$(RUN) ; ./autogen.sh

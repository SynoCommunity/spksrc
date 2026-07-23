PKG_NAME = Comskip
PKG_VERS = 0.83
PKG_EXT = tar.gz
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_NAME = V$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/erikkaashoek/Comskip/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/argtable
OPTIONAL_DEPENDS = cross/ffmpeg8

# ffmpeg8 needs C11 -- gcc 4.9 or newer
MIN_GCC_VERSION = 4.9

HOMEPAGE = https://www.kaashoek.com/comskip
COMMENT  = Commercial detector
LICENSE  = GNU/LGPL

PRE_CONFIGURE_TARGET = comskip_pre_configure
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: comskip_pre_configure
comskip_pre_configure:
	@$(RUN) ; ./autogen.sh

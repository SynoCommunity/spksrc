PKG_NAME = lcms2
PKG_VERS = 2.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.sourceforge.net/project/lcms/lcms/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.littlecms.com/
COMMENT  = Little CMS intends to be an OPEN SOURCE small-footprint color management engine, with special focus on accuracy and performance
LICENSE  = MIT License


GNU_CONFIGURE = 1
CONFIGURE_ARGS = --libdir=$(INSTALL_DIR)$(INSTALL_PREFIX)/lib


include ../../mk/spksrc.cross-cc.mk

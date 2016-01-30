PKG_NAME = twolame
PKG_VERS = 0.3.13
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/twolame/files/$(PKG_NAME)/$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://www.twolame.org/
COMMENT  = Optimised MPEG Audio Layer 2 (MP2) encoder based on tooLAME by Mike Cheng, which in turn is based upon the ISO dist10 code and portions of LAME.
LICENSE  = 

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --enable-shared

include ../../mk/spksrc.cross-cc.mk


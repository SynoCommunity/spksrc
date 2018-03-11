PKG_NAME = libva
PKG_VERS = 2.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/libva/archive
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libdrm

HOMEPAGE = 
COMMENT  = 
LICENSE = 

PRE_CONFIGURE_TARGET = myPreConfigure

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) ./autogen.sh

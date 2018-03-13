PKG_NAME = intel-vaapi-driver
PKG_VERS = 2.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/intel-vaapi-driver/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libva

HOMEPAGE = https://01.org/linuxmedia
COMMENT = VA-API user mode driver for Intel GEN Graphics family
LICENSE = MIT

PRE_CONFIGURE_TARGET = myPreConfigure

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) ./autogen.sh

PKG_NAME = curaengine
PKG_VERS = 15.04
PKG_EXT = tar.gz
PKG_DIST_SITE = https://github.com/Ultimaker/CuraEngine/archive
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = CuraEngine-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://ultimaker.com
COMMENT  = CuraEngine is a powerful, fast and robust engine for processing 3D models into 3D printing instruction for Ultimaker and other GCode based 3D printers.
LICENSE  = AGPLv3

POST_EXTRACT_TARGET = myPostExtract
CONFIGURE_TARGET = nope
INSTALL_TARGET = myInstall

PATCHES_LEVEL = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPostExtract
myPostExtract:
	sed -i "s/\r//" $(EXTRACT_PATH)/$(PKG_DIR)/src/utils/gettime.h

.PHONY: myInstall
myInstall:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/build/CuraEngine $(STAGING_INSTALL_PREFIX)/bin/

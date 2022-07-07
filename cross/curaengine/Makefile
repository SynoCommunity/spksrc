PKG_NAME = curaengine
PKG_VERS = 2.1.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Ultimaker/CuraEngine/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = CuraEngine-$(PKG_VERS)

DEPENDS = cross/libarcus

# c++11 compiler required
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

HOMEPAGE = https://ultimaker.com/software/ultimaker-cura
COMMENT  = CuraEngine is a Powerful, fast and robust engine for converting 3D models into g-code instructions for 3D printers. It is part of the larger open source project Cura.
LICENSE  = AGPLv3

POST_INSTALL_TARGET = curaengine_post_install

ADDITIONAL_CXXFLAGS = -fPIC

ENV += PATH=$(WORK_DIR)/../../../native/protoc/work-native/bin:$$PATH  

include ../../mk/spksrc.cross-cmake.mk

.PHONY: curaengine_post_install
curaengine_post_install:
	@install -m 755 $(WORK_DIR)/$(PKG_DIR)/build/lib_CuraEngine.so $(STAGING_INSTALL_PREFIX)/lib/

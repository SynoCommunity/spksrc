PKG_NAME = icu
PKG_VERS = 65
PKG_MINOR_VERS = 1
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)4c-$(PKG_VERS)_$(PKG_MINOR_VERS)-src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/unicode-org/icu/releases/download/release-$(PKG_VERS)-$(PKG_MINOR_VERS)
PKG_DIR = $(PKG_NAME)/source

DEPENDS = native/$(PKG_NAME)

HOMEPAGE = http://site.icu-project.org/
COMMENT  = ICU is a mature, widely used set of libraries providing Unicode and Globalization support for software applications.
LICENSE  = Unicode Copyright

# ADDITIONAL_CFLAGS = -I$(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/common/ -I$(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/tools/tzcode/
# ADDITIONAL_CXXFLAGS = I$(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/common/ -I$(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/tools/tzcode/
# ADDITIONAL_LDFLAGS =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --host=$(TC_TARGET) --with-cross-build=$(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)
CONFIGURE_ARGS += --enable-extras=no --enable-strict=no --enable-tests=no --enable-samples=no
# CONFIGURE_ARGS += --with-data-packaging=files

include ../../mk/spksrc.cross-cc.mk

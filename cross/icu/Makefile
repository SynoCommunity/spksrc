PKG_NAME = icu
PKG_VERS = 56.1
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)4c-$(subst .,_,$(PKG_VERS))-src.$(PKG_EXT)
PKG_DIST_SITE = http://download.icu-project.org/files/$(PKG_NAME)4c/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)

DEPENDS = 

HOMEPAGE = http://site.icu-project.org/
COMMENT  = International Components for Unicode
LICENSE  = 

CONFIGURE_ARGS  = --with-cross-build=$(WORK_DIR)/$(PKG_DIR)_build_a  --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --disable-tools --disable-tests --disable-samples --disable-static --enable-shared --with-data-packaging=library
ADDITIONAL_CXXFLAGS = --std=c++0x
CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = none
INSTALL_TARGET = myInstall

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	mkdir -p $(WORK_DIR)/$(PKG_DIR)_build_a
	cd $(WORK_DIR)/$(PKG_DIR)_build_a && CPP= CC= CXX= CPPFLAGS= CFLAGS= CXXFLAGS= LDFLAGS= MAKE= $(WORK_DIR)/$(PKG_DIR)/source/runConfigureICU Linux/gcc
	cd $(WORK_DIR)/$(PKG_DIR)_build_a && make
include ../../mk/spksrc.cross-env.mk

.PHONY: myInstall
myInstall:
	mkdir -p $(WORK_DIR)/$(PKG_DIR)_build_b
	cd $(WORK_DIR)/$(PKG_DIR)_build_b && env $(ENV) $(WORK_DIR)/$(PKG_DIR)/source/configure --host=$(TC_TARGET) $(CONFIGURE_ARGS)
	cd $(WORK_DIR)/$(PKG_DIR)_build_b && env $(ENV) make
	cd $(WORK_DIR)/$(PKG_DIR)_build_b && env $(ENV) make install DESTDIR=$(INSTALL_DIR)


PKG_NAME = icinga2-tools
PKG_VERS = 2.15.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Icinga/icinga2/archive/refs/tags
PKG_DIST_FILE = icinga2-2.15.2.tar.gz
PKG_DIR = icinga2-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://icinga.com/
COMMENT  = Native build tools for Icinga 2 (mkclass, mkembedconfig, mkunity)
LICENSE  = GPLv2

CONFIGURE_TARGET = nop
COMPILE_TARGET = native_tools_build
INSTALL_TARGET = native_tools_install

include ../../mk/spksrc.native-cc.mk

NATIVE_BUILD_DIR = $(WORK_DIR)/$(PKG_DIR)/native-build

.PHONY: native_tools_build
native_tools_build:
	@$(MSG) "Building native host tools (mkclass, mkembedconfig, mkunity)"
	mkdir -p $(NATIVE_BUILD_DIR)/Bin/Release
	cc -O2 -o $(NATIVE_BUILD_DIR)/Bin/Release/mkembedconfig \
		$(WORK_DIR)/$(PKG_DIR)/tools/mkembedconfig/mkembedconfig.c
	cc -O2 -o $(NATIVE_BUILD_DIR)/Bin/Release/mkunity \
		$(WORK_DIR)/$(PKG_DIR)/tools/mkunity/mkunity.c
	mkdir -p $(NATIVE_BUILD_DIR)/mkclass
	cd $(NATIVE_BUILD_DIR)/mkclass && \
		bison -d -o class_parser.cc $(WORK_DIR)/$(PKG_DIR)/tools/mkclass/class_parser.yy && \
		flex -o class_lexer.cc $(WORK_DIR)/$(PKG_DIR)/tools/mkclass/class_lexer.ll && \
		g++ -O2 -std=c++17 -I. -I$(WORK_DIR)/$(PKG_DIR)/tools/mkclass -o $(NATIVE_BUILD_DIR)/Bin/Release/mkclass \
			$(WORK_DIR)/$(PKG_DIR)/tools/mkclass/mkclass.cpp \
			$(WORK_DIR)/$(PKG_DIR)/tools/mkclass/classcompiler.cpp \
			class_parser.cc \
			class_lexer.cc

.PHONY: native_tools_install
native_tools_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	cp $(NATIVE_BUILD_DIR)/Bin/Release/mkclass $(STAGING_INSTALL_PREFIX)/bin/
	cp $(NATIVE_BUILD_DIR)/Bin/Release/mkembedconfig $(STAGING_INSTALL_PREFIX)/bin/
	cp $(NATIVE_BUILD_DIR)/Bin/Release/mkunity $(STAGING_INSTALL_PREFIX)/bin/

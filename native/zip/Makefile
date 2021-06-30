PKG_NAME = zip
PKG_VERS = 30
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://altushost-swe.dl.sourceforge.net/project/infozip/Zip%203.x%20%28latest%29/3.0
PKG_DIR = $(PKG_NAME)$(PKG_VERS)

HOMEPAGE = http://infozip.sourceforge.net/
COMMENT  = Zip - a compressor/archiver for creating and modifying zipfiles.
LICENSE  = BSD-like

CONFIGURE_TARGET = nop
COMPILE_TARGET = native_zip_compile
INSTALL_TARGET = native_zip_install

include ../../mk/spksrc.native-cc.mk

.PHONY: native_zip_compile
native_zip_compile:
	$(RUN) $(MAKE) -f unix/Makefile generic

.PHONY: native_zip_install
native_zip_install:
	$(RUN) $(MAKE) -f unix/Makefile prefix=$(INSTALL_DIR)$(INSTALL_PREFIX) install
	cd $(INSTALL_DIR)$(INSTALL_PREFIX)/bin && ln -s zip unzip

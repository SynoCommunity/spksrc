PKG_NAME = xavs2
PKG_VERS = 1.4
PKG_EXT = tar.gz
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/pkuvcl/xavs2/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://github.com/pkuvcl/xavs2
COMMENT  = xavs2 is an open-source encoder of AVS2-P2/IEEE1857.4 video coding standard.
LICENSE  = GPL-2.0

CONFIGURE_TARGET = xavs2_configure
COMPILE_TARGET = xavs2_compile
INSTALL_TARGET = xavs2_install

CONFIGURE_ARGS += --prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --enable-shared
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --disable-asm

include ../../mk/spksrc.cross-cc.mk

.PHONY: xavs2_configure
xavs2_configure:
	$(RUN) ; cd build/linux ; ./configure $(CONFIGURE_ARGS)

.PHONY: xavs2_compile
xavs2_compile:
	$(RUN) ; cd build/linux ; $(MAKE)

.PHONY: xavs2_install
xavs2_install:
	$(RUN) ; cd build/linux ; $(MAKE) install

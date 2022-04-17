PKG_NAME = davs2
PKG_VERS = 1.7
PKG_EXT = tar.gz
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/pkuvcl/davs2/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://github.com/pkuvcl/davs2
COMMENT  = davs2 is an open-source decoder of AVS2-P2/IEEE1857.4 video coding standard.
LICENSE  = GPL-2.0

CONFIGURE_TARGET = davs2_configure
COMPILE_TARGET = davs2_compile
INSTALL_TARGET = davs2_install

CONFIGURE_ARGS += --prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --enable-shared
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --disable-asm

include ../../mk/spksrc.cross-cc.mk

.PHONY: davs2_configure
davs2_configure:
	$(RUN) ; cd build/linux ; ./configure $(CONFIGURE_ARGS)

.PHONY: davs2_compile
davs2_compile:
	$(RUN) ; cd build/linux ; $(MAKE)

.PHONY: davs2_install
davs2_install:
	$(RUN) ; cd build/linux ; $(MAKE) install

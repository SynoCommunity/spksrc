PKG_NAME = pngquant
PKG_VERS = 2.9.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/pornel/pngquant/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
LIBIMAGEQUANT_FILE = https://github.com/ImageOptim/libimagequant/archive/$(PKG_VERS).tar.gz

DEPENDS = /cross/zlib /cross/libpng

HOMEPAGE = https://pngquant.org/
COMMENT  = pngquant is a command-line utility and a library for lossy compression of PNG images.
LICENSE  = GPL

PRE_CONFIGURE_TARGET = myPreConfigure

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --prefix=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH), $(PPC_ARCHES) $(ARM_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --disable-sse
endif

.PHONY: myPreConfigure
myPreConfigure:
	@$(RUN) install -m 755 -d $(STAGING_DIR)/tmp
	@$(RUN) install -m 755 -d $(STAGING_DIR)/../$(PKG_DIR)/lib
	@$(RUN) wget $(LIBIMAGEQUANT_FILE) -O $(STAGING_DIR)/tmp/$(PKG_VERS).tar.gz
	@$(RUN) tar xf $(STAGING_DIR)/tmp/$(PKG_VERS).tar.gz -C $(STAGING_DIR)/../$(PKG_DIR)/lib --strip 1
	@$(RUN) rm -rf $(STAGING_DIR)/tmp

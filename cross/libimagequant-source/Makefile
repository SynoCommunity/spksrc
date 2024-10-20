PKG_NAME = libimagequant
PKG_VERS = 4.3.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ImageOptim/libimagequant/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://pngquant.org/lib/
COMMENT  = Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images.
LICENSE  = GPLv3

INSTALL_TARGET = nop

include ../../mk/spksrc.install-resources.mk

.PHONY: libimagequant_install
libimagequant_install:
	@$(MSG) "Extract the sources only"
	@mkdir -p "$(INSTALL_DIR)/$(INSTALL_PREFIX)/source/"
	@tar -cf - -C $(EXTRACT_PATH) . | tar -xf - -C "$(INSTALL_DIR)/$(INSTALL_PREFIX)/source/"

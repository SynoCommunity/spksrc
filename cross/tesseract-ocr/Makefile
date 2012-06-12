PKG_NAME = tesseract
PKG_VERS = 3.01
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://tesseract-ocr.googlecode.com/files
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/leptonica

HOMEPAGE = http://code.google.com/p/tesseract-ocr/
COMMENT  = Tesseract Open Source OCR Engine
LICENSE  = APACHE LICENSE 2.0


ENV += LIBLEPT_HEADERSDIR=$(INSTALL_DIR)/$(INSTALL_PREFIX)/include
GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = myPreConfigure

include ../../mk/spksrc.cross-cc.mk


.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) ./autogen.sh


PKG_NAME = tesseract-ocr-eng
PKG_VERS = 3.02
PKG_LNG = eng
PKG_EXT = tar.gz
PKG_DIST_NAME = tesseract-ocr-$(PKG_VERS).$(PKG_LNG).$(PKG_EXT)
PKG_DIST_SITE = http://tesseract-ocr.googlecode.com/files
PKG_DIR = tesseract-ocr

DEPENDS =

HOMEPAGE = https://code.google.com/p/tesseract-ocr/
COMMENT  = English language data for Tesseract.
LICENSE  = Apache License 2.0


EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/tessdata
	tar -cf - -C $(WORK_DIR)/$(PKG_NAME)/$(PKG_DIR)/tessdata . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/tessdata

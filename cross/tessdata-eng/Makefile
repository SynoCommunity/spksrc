PKG_NAME = tessdata-eng
PKG_VERS = 3.04.00
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/tesseract-ocr/tessdata/archive
PKG_DIST_FILE = tessdata-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = tessdata-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/tesseract-ocr/tessdata/
COMMENT  = Tesseract is probably the most accurate open source OCR engine available. English langpack.
LICENSE  = Apache License 2.0

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/tessdata
	cp $(WORK_DIR)/$(PKG_DIR)/eng.* $(STAGING_INSTALL_PREFIX)/share/tessdata

PKG_NAME = tessdata-eng
PKG_VERS = 3.02
PKG_EXT = tar.gz
PKG_DIST_NAME = tesseract-ocr-$(PKG_VERS).eng.$(PKG_EXT)
PKG_DIST_SITE = http://heanet.dl.sourceforge.net/project/tesseract-ocr-alt
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://code.google.com/p/tesseract-ocr/
COMMENT  = Tesseract is probably the most accurate open source OCR engine available. English langpack.
LICENSE  = Apache License 2.0

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/tessdata
	cp $(WORK_DIR)/tesseract-ocr/tessdata/eng.* $(STAGING_INSTALL_PREFIX)/share/tessdata

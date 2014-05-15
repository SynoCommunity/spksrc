PKG_NAME = tesseract-ocr
PKG_VERS = 3.02.02
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://tesseract-ocr.googlecode.com/files
PKG_DIR = $(PKG_NAME)

DEPENDS = cross/leptonica

HOMEPAGE = https://code.google.com/p/tesseract-ocr/
COMMENT  = Tesseract is probably the most accurate open source OCR engine available.
LICENSE  = Apache License 2.0

GNU_CONFIGURE = 1
CONFIGURE_ARGS = LIBLEPT_HEADERSDIR=$(STAGING_INSTALL_PREFIX)/include/leptonica

include ../../mk/spksrc.cross-cc.mk


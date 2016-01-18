PKG_NAME = tesseract
PKG_VERS = 3.04.00
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-ocr-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/tesseract-ocr/$(PKG_NAME)/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/leptonica

HOMEPAGE = https://github.com/tesseract-ocr/tesseract
COMMENT  = Tesseract is probably the most accurate open source OCR engine available. This pkg is binary only.
LICENSE  = Apache License 2.0

GNU_CONFIGURE = 1
CONFIGURE_ARGS = LIBLEPT_HEADERSDIR=$(STAGING_INSTALL_PREFIX)/include/leptonica

include ../../mk/spksrc.cross-cc.mk


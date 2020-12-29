PKG_NAME = tesseract
PKG_VERS = 3.05.02
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

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
# workaround and experimental c++ features for g++ compiler:
ADDITIONAL_CXXFLAGS = -D nullptr=NULL -std=gnu++0x
endif
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
# enable experimental features for (old) g++ compiler:
ADDITIONAL_CXXFLAGS = -std=gnu++0x
endif

PRE_CONFIGURE_TARGET = tesseract_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: tesseract_pre_configure
tesseract_pre_configure:
	$(RUN) ./autogen.sh

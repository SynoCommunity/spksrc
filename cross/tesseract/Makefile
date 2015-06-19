
PKG_NAME = tesseract
PKG_VERS = 3.01
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://tesseract-ocr.googlecode.com/files
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/leptonica

HOMEPAGE = http://code.google.com/p/tesseract-ocr
COMMENT  = An OCR Engine that was developed at HP Labs between 1985 and 1995... and now at Google.
LICENSE  = Apache 2.0 License

GNU_CONFIGURE = 1 
CONFIGURE_ARGS = --disable-dependency-tracking --disable-static \
                 --with-extra-libraries=${STAGING_INSTALL_PREFIX}/lib \
                 LIBLEPT_HEADERSDIR=${STAGING_INSTALL_PREFIX}/include

POST_PATCH_TARGET = myPostPatch

PRE_CONFIGURE_TARGET = myPreConfigure

include ../../mk/spksrc.cross-cc.mk

myPostPatch:
	@$(MSG) "  Removing utf-8 BOM from ccutil/strngs.h"
	@$(RUN) mv ccutil/strngs.h ccutil/strngs.h.orig
	@$(RUN) perl -wp -e '$$. == 1 && s/^\xef\xbb\xbf//;' < ccutil/strngs.h.orig > ccutil/strngs.h

myPreConfigure:
	@$(MSG) "  Running automake"
	@$(RUN) automake

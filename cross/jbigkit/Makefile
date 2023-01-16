PKG_NAME = jbigkit
PKG_VERS = 2.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/void-linux/jbigkit-shared/archive
PKG_DIST_FILE = $(PKG_NAME)-shared-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-shared-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.cl.cam.ac.uk/~mgk25/jbigkit/
COMMENT  = JBIG-KIT is a software implementation of the JBIG1 data compression standard (ITU-T T.82), which was designed for bi-level image data, such as scanned documents.
LICENSE  = GPLv3

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = jbigkit_pre_configure

ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk

.PHONY: jbigkit_pre_configure
jbigkit_pre_configure:
	@$(RUN) ./bootstrap.sh

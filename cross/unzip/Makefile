PKG_NAME = unzip
PKG_VERS = 60
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.info-zip.org/pub/infozip/src
PKG_DIR = $(PKG_NAME)$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://infozip.org/UnZip.html
COMMENT  = UnZip is an extraction utility for archives compressed in .zip format
LICENSE  = http://infozip.org/license.html

CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile

include ../../mk/spksrc.cross-cc.mk

.PHONY: MyConfigure
myConfigure:
	cp $(WORK_DIR)/$(PKG_DIR)/unix/Makefile $(WORK_DIR)/$(PKG_DIR)

.PHONY: myCompile
myCompile:
	$(RUN) $(MAKE) generic CC="$(TC_PATH)$(TC_PREFIX)gcc"

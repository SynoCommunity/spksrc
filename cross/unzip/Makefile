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

GNU_CONFIGURE = 1
CONFIGURE_TARGET = none
COMPILE_TARGET = unzip_compile
INSTALL_TARGET = unzip_install

include ../../mk/spksrc.cross-cc.mk


.PHONY: unzip_compile
unzip_compile:
	$(RUN) $(MAKE) -f unix/Makefile generic CC="$(TC_PATH)$(TC_PREFIX)gcc"

.PHONY: unzip_install
unzip_install:
	$(RUN) $(MAKE) -f unix/Makefile install prefix=$(INSTALL_DIR)$(INSTALL_PREFIX)

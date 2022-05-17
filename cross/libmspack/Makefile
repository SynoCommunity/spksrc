PKG_NAME = libmspack
PKG_VERS = 1.9.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/kyz/libmspack/archive
PKG_DIST_FILE = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)/$(PKG_NAME)

DEPENDS =

HOMEPAGE = https://www.cabextract.org.uk/libmspack/
COMMENT  = A library for some loosely related Microsoft compression formats, CAB, CHM, HLP, LIT, KWAJ and SZDD.
LICENSE  = LGPLv2.1

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = libmspack_pre_configure
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk

.PHONY: libmspack_pre_configure
libmspack_pre_configure:
	@$(RUN) ./autogen.sh

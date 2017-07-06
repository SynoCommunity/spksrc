PKG_NAME = libtasn1
PKG_VERS = 4.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.gnu.org/software/libtasn1/
COMMENT  = ASN.1 library
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-gcc-warnings
PRE_COMPILE_TARGET = myPreCompile

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreCompile
myPreCompile:
	mkdir -p $(STAGING_INSTALL_PREFIX)/include
	$(RUN) $(MAKE)

PKG_NAME = gdbm
PKG_VERS = 1.8.3
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)

DEPENDS =

HOMEPAGE = http://gnu.org
COMMENT  = Package that contains the GNU Database Manager
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --enable-shared --prefix=$(STAGING_INSTALL_PREFIX)
PATCH_TARGET = patch_target myPatch

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPatch
myPatch:
	$(RUN) sed -ie 's/\(\$$(INSTALL_DATA)\) -o \$$(BINOWN) -g \$$(BINGRP)/\1/g' Makefile.in

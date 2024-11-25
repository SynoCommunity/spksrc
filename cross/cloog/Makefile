PKG_NAME = cloog
PKG_VERS = 0.20.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/periscop/cloog/archive
#PKG_DIST_SITE = http://www.bastoul.net/cloog/pages/download/count.php3?url=./
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/isl

HOMEPAGE = http://www.bastoul.net/cloog/index.php
COMMENT  = CLooG is a free software and library to generate code for scanning Z-polyhedra.
LICENSE  = LGPL-2.1

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = cloog_pre_configure

CONFIGURE_ARGS +=--with-isl=system
CONFIGURE_ARGS +=--with-gmp=system

include ../../mk/spksrc.cross-cc.mk

.PHONY: cloog_pre_configure
cloog_pre_configure:
	@$(RUN) ; ./autogen.sh

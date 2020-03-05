PKG_NAME = fossil-scm
PKG_VERS = 2.10
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.fossil-scm.org/index.html/tarball/version-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

BUILD_DEPENDS = cross/zlib
BUILD_DEPENDS += cross/openssl

HOMEPAGE = http://www.fossil-scm.org/
COMMENT  = Fossil is a simple, high-reliability, distributed software configuration management system.
LICENSE  = http://www.fossil-scm.org/home/doc/trunk/COPYRIGHT-BSD2.txt

PRE_CONFIGURE_TARGET = fixMakefileIn

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --static --json 
CONFIGURE_ARGS += --disable-fusefs 
CONFIGURE_ARGS += --with-th1-docs --with-th1-hooks 
CONFIGURE_ARGS += --with-openssl=auto

include ../../mk/spksrc.cross-cc.mk

.PHONY: fixMakefileIn
fixMakefileIn:
	sed -i.orig -e "s|^BCCFLAGS.*$$|BCCFLAGS = |" $(WORK_DIR)/$(PKG_DIR)/Makefile.in


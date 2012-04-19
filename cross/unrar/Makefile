PKG_NAME = unrar
PKG_VERS = 4.1.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)src-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://rarlab.com/rar
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE = http://rarlab.com/
COMMENT  = Extract files from rar archives
LICENSE  = 

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile:
	$(RUN) $(MAKE) -f makefile.unix

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) -f makefile.unix install DESTDIR=$(STAGING_INSTALL_PREFIX)


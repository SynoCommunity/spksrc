PKG_NAME = dtach
PKG_VERS = 0.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/dtach/dtach/${PKG_VERS}
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://dtach.sourceforge.net/
COMMENT  = dtach is a tiny program that emulates the detach feature of screen, allowing you to run a program in an environment that is protected from the controlling terminal and attach to it later.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
INSTALL_TARGET = dtach_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: dtach_install
dtach_install:
	mkdir -p $(WORK_DIR)/install/$(INSTALL_PREFIX)/bin
	cp $(WORK_DIR)/$(PKG_DIR)/dtach $(WORK_DIR)/install/$(INSTALL_PREFIX)/bin/

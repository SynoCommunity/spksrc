PKG_NAME = plowshare
PKG_VERS = 2.1.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mcrapet/$(PKG_NAME)/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/mcrapet/plowshare
COMMENT  = Command-line tool and engine for managing sharing websites 
LICENSE  = GPLv3

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install PREFIX=$(INSTALL_PREFIX) DESTDIR=$(INSTALL_DIR)
	sed -i "s|^#!/usr/bin/env bash|#!/usr/bin/env $(INSTALL_PREFIX)/bin/bash|g" $(INSTALL_DIR)/$(INSTALL_PREFIX)/share/plowshare/*.sh
	sed -i "s|img2txt|$(INSTALL_PREFIX)/bin/img2txt|g" $(INSTALL_DIR)/$(INSTALL_PREFIX)/share/plowshare/core.sh


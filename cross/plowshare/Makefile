PKG_NAME = plowshare
PKG_VERS = 2.1.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mcrapet/plowshare/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

OPTIONAL_DEPENDS = cross/bash

HOMEPAGE = https://github.com/mcrapet/plowshare
COMMENT  = Command-line tool and engine for managing sharing websites.
LICENSE  = GPLv3

INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)

POST_INSTALL_TARGET = plowshare_post_install

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, $(TCVERSION), 6.0),1)
# install and patch for bash for DSM <= 5.x
POST_INSTALL_TARGET += bash_post_install
DEPENDS += cross/bash
endif

include ../../mk/spksrc.install-resources.mk

.PHONY: plowshare_post_install
plowshare_post_install:
	sed -i "s|img2txt|$(INSTALL_PREFIX)/bin/img2txt|g" $(STAGING_INSTALL_PREFIX)/share/plowshare/core.sh

.PHONY: bash_post_install
bash_post_install:
	@sed -i "s|^#!/usr/bin/env bash|#!/usr/bin/env $(INSTALL_PREFIX)/bin/bash|g" $(STAGING_INSTALL_PREFIX)/share/plowshare/*.sh

PKG_NAME = duply
PKG_VERS = 2.3.1
PKG_SHORT_VERS = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/ftplicity/files/duply%20%28simple%20duplicity%29/$(PKG_SHORT_VERS).x
PKG_DIR = $(PKG_NAME)_$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://duply.net
COMMENT  = duply is a frontend for the mighty duplicity magic. duplicity is a python based shell application that makes encrypted incremental backups to remote storages.
LICENSE  = GPLv2

INSTALL_TARGET = duply_install

include ../../mk/spksrc.install-resources.mk

.PHONY: duply_install
duply_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/bin

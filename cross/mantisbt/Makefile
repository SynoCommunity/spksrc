PKG_NAME = mantisbt
PKG_VERS = 1.2.19
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/$(PKG_NAME)/files/mantis-stable/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.mantisbt.org
COMMENT  = Mantis is an easily deployable, web based bugtracker to aid product bug tracking. It requires PHP, MySQL and a web server. It is simpler than Bugzilla and easily editable.
LICENSE  = GPL

EXTRACT_PATH = $(WORK_DIR)

INSTALL_TARGET = mantisbt_install

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.install-resources.mk

.PHONY: mantisbt_install
mantisbt_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/mantisbt
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/mantisbt
	chmod -R 755 $(STAGING_INSTALL_PREFIX)/share/mantisbt
	chmod 777 $(STAGING_INSTALL_PREFIX)/share/mantisbt

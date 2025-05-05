PKG_NAME = saltgui
PKG_VERS = 1.31.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/erwindon/SaltGUI/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = SaltGUI-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/erwindon/SaltGUI
COMMENT  = A new open source web interface for managing a SaltStack server. Built using vanilla ES6 and implemented as a wrapper around the rest_cherrypy server.
LICENSE  = MIT

INSTALL_TARGET = saltgui_install

include ../../mk/spksrc.install-resources.mk

.PHONY: saltgui_install
saltgui_install:
	install -m 750 -d $(STAGING_INSTALL_PREFIX)/var
	rsync -avh --ignore-existing $(WORK_DIR)/$(PKG_DIR)/saltgui $(STAGING_INSTALL_PREFIX)/var/
	install -m 644 src/salt-auth.txt $(STAGING_INSTALL_PREFIX)/var/saltgui/static/salt-auth.txt

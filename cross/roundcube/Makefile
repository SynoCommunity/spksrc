PKG_NAME = roundcubemail
PKG_VERS = 1.1.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-complete.$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/roundcubemail/roundcubemail/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.roundcube.net
COMMENT  = Roundcube is a free and open source webmail solution with a desktop-like user interface which is easy to install/configure and that runs on a standard LAMPP server. It is the same software Synology offers as Mail Station except this does not depend on Mail Server package.
LICENSE  = GPLv3

INSTALL_TARGET = roundcubemail_install

include ../../mk/spksrc.install-resources.mk

.PHONY: roundcubemail_install
roundcubemail_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/roundcube
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/roundcube

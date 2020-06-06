PKG_NAME = SABnzbd
PKG_VERS = 2.3.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/sabnzbd/sabnzbd/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://sabnzbd.org
COMMENT  = Usenet binary downloader
LICENSE  = GPL

INSTALL_TARGET = sabnzbd_install


include ../../mk/spksrc.install-resources.mk

sabnzbd_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/SABnzbd
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/SABnzbd

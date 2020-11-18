PKG_NAME = SABnzbd
PKG_VERS = 3.1.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-src.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/sabnzbd/sabnzbd/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://sabnzbd.org
COMMENT  = Usenet binary downloader
LICENSE  = GPL

INSTALL_TARGET = sabnzbd_install

include ../../mk/spksrc.install-resources.mk

# Need to replace the path to python in the shebang of Deobfuscate.py
sabnzbd_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/SABnzbd
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/SABnzbd
	sed -i '1s/\/usr\/bin/\/usr\/local/' $(STAGING_INSTALL_PREFIX)/share/SABnzbd/scripts/Deobfuscate.py

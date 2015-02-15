PKG_NAME = SABnzbd
PKG_VERS = 0.7.19
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-src.$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/sabnzbdplus/sabnzbdplus/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

<<<<<<< HEAD
HOMEPAGE = http://sabnzbd.org/
COMMENT  = Usenet binary downloader
LICENSE  = GPL
=======
MAINTAINER = superzebulon@superzebulon.org
HOMEPAGE   = http://sabnzbd.org/
COMMENT    = "Usenet binary downloader"
LICENSE    = GPL
>>>>>>> upstream/master

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/SABnzbd
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/SABnzbd

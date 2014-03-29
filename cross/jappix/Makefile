PKG_NAME = jappix
PKG_VERS = 1.0.1
PKG_RELEASE_NAME = one
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-$(PKG_RELEASE_NAME).$(PKG_EXT)
PKG_DIST_SITE = http://download.jappix.org/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE = http://jappix.org/
COMMENT  = Jappix, a full-featured XMPP web-client (Jappix Desktop, Jappix Mobile & Jappix Mini). Jappix is a fresh new open social platform which enables you to create your own cloud, wherever you want to. People must be able to get in touch with all their friends on a free decentralized network!
LICENSE  = AGPL

EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/jappix
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR)/jappix . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/jappix

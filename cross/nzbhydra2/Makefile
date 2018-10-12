PKG_NAME = NZBHydra2
PKG_VERS = 2.0.9
PKG_REPO = theotherp
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-linux.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/$(PKG_REPO)/$(PKG_NAME)/releases/download/v$(PKG_VERS)
PKG_DIR = NZBHydra2

DEPENDS =

HOMEPAGE = http://github.com/theotherp/nzbhydra2
COMMENT  = NZBHydra 2 is a meta search for NZB indexers. It provides easy access to a number of raw and newznab based indexers. You can search all your indexers from one place and use it as indexer source for tools like Sonarr or CouchPotato. It's a complete rewrite of NZBHydra (1). It's currently in Beta. It works mostly fine but some functions might not be completely done and incompatibilities with some tools might still exist.
LICENSE  = ApacheV2

EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)

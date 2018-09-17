PKG_NAME = dtach
PKG_VERS = 0.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/${PKG_NAME}/dtach/${PKG_VERS}
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://dtach.sourceforge.net/
COMMENT  = dtach is a tiny program that emulates the detach feature of screen, allowing you to run a program in an environment that is protected from the controlling terminal and attach to it later.
LICENSE  = GNU GPL

GNU_CONFIGURE = 1
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	@$(RUN) mkdir -p $(WORK_DIR)/install/$(INSTALL_PREFIX)/bin
	@$(RUN) cp $(SRC_DIR)dtach $(WORK_DIR)/install/$(INSTALL_PREFIX)/bin/

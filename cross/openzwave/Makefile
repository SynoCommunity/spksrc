PKG_NAME = openzwave
PKG_VERS = 1.2.919
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://old.openzwave.com/downloads
PKG_DIR = open-zwave-read-only

HOMEPAGE = http://www.openzwave.com/
COMMENT  = A Open Source implementation of the ZWave Serial API
LICENSE  = GPL

ENV += CROSS_COMPILE=$(TC_PATH)$(TC_PREFIX)

POST_EXTRACT_TARGET = myPostExtract
CONFIGURE_TARGET = nope
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPostExtract
myPostExtract:
	mv $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS) $(WORK_DIR)/$(PKG_DIR)

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)

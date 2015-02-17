PKG_NAME = openzwave
PKG_VERS = $(PKG_SVN_REV)
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = svn
PKG_DOWNLOAD_VCS_CLEAN = nope
PKG_SVN_REV = 1009
PKG_DIST_NAME = trunk
PKG_DIST_SITE = http://open-zwave.googlecode.com/svn
PKG_DIST_FILE = $(PKG_NAME)-r$(PKG_SVN_REV).$(PKG_EXT)
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
	mv $(WORK_DIR)/$(PKG_NAME)-r$(PKG_SVN_REV) $(WORK_DIR)/$(PKG_DIR)

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)

PKG_NAME = oscam
PKG_VERS = $(shell date +%Y%m%d)
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/gfto/oscam/tarball/master
PKG_DIR = gfto-$(PKG_NAME)-*

DEPENDS = cross/openssl cross/libusb

HOMEPAGE = http://oscam.to/
COMMENT  = OSCam is an Open Source Conditional Access Module software
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_TARGET = myConfigure
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) ./config.sh --enable WITH_SSL

.PHONY: myInstall
myInstall:
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/Distribution/oscam* $(STAGING_INSTALL_PREFIX)/bin/oscam
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/Distribution/list_smargo* $(STAGING_INSTALL_PREFIX)/bin/list_smargo

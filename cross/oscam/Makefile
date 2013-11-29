PKG_NAME = oscam
PKG_VERS = 1.20
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = svn
PKG_SVN_REV = 9041
PKG_DIST_NAME = trunk
PKG_DIST_SITE = http://www.streamboard.tv/svn/oscam
PKG_DIST_FILE = $(PKG_NAME)-r$(PKG_SVN_REV).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-r*

DEPENDS = cross/openssl cross/libusb

HOMEPAGE = http://oscam.to/
COMMENT  = OSCam is an Open Source Conditional Access Module software
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_TARGET = myConfigure
COMPILE_TARGET = myCompile
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) ./config.sh --enable WITH_SSL --disable HAVE_DVBAPI

.PHONY: myCompile
myCompile:
	$(RUN) $(MAKE) CROSS=$(shell echo $(ENV) | sed 's/ /\n/g' | sed -n -e 's/CC=\(.*-\)gcc/\1/p') CONF_DIR=$(INSTALL_PREFIX)/etc USE_LIBUSB=1

.PHONY: myInstall
myInstall:
	rm -f $(WORK_DIR)/$(PKG_DIR)/Distribution/oscam*.debug
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/Distribution/list_smargo* $(STAGING_INSTALL_PREFIX)/bin/list_smargo
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/Distribution/oscam* $(STAGING_INSTALL_PREFIX)/bin/oscam

PKG_NAME = oscam-8917
PKG_VERS = 1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/R0T13Z/oscam-8917/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libusb cross/pcsc-lite

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
	$(RUN) chmod 755 config.sh
	$(RUN) chmod 755 webif/pages_mkdep
	$(RUN) ./config.sh --enable WITH_SSL --disable HAVE_DVBAPI

.PHONY: myCompile
myCompile:
	$(RUN) $(MAKE) CROSS=$(shell echo $(ENV) | sed 's/ /\n/g' | sed -n -e 's/CC=\(.*-\)gcc/\1/p') CONF_DIR=$(INSTALL_PREFIX)/etc USE_LIBUSB=1 USE_PCSC=1

.PHONY: myInstall
myInstall:
	rm -f $(WORK_DIR)/$(PKG_DIR)/Distribution/oscam*.debug
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/Distribution/list_smargo* $(STAGING_INSTALL_PREFIX)/bin/list_smargo
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/Distribution/oscam* $(STAGING_INSTALL_PREFIX)/bin/oscam

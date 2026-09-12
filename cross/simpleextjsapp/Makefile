PKG_NAME = SimpleExtJSApp
PKG_VERS = 0.73
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/DigitalBox98/SimpleExtJSApp/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/DigitalBox98/
COMMENT  = A simple ExtJS Application for DSM 

GNU_CONFIGURE = 1

# Make sure ARCH is not defined
override ARCH=

INSTALL_TARGET = simpleextjsapp_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: simpleextjsapp_install
simpleextjsapp_install:
	# remove the test.cgi part in order to have a pure "docs" cross part 
	##$(RUN) make install prefix=$(STAGING_INSTALL_PREFIX) 
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/web 
	tar -xvf $(WORK_DIR)/$(PKG_DIR)/docs/synoextjsdocs.tar.gz -C $(STAGING_INSTALL_PREFIX)/web/

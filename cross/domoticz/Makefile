PKG_NAME = domoticz
PKG_VERS = 4.9700
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/domoticz/domoticz/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/boost cross/sqlite cross/curl cross/python3

HOMEPAGE = https://www.domoticz.com/
COMMENT  = Domoticz is a Home Automation System.
LICENSE  = GPLv3

CONFIGURE_TARGET = domoticz_configure
INSTALL_TARGET = domoticz_install

BOOST_LIBRARIES = system thread date_time
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)" CMAKE_INCLUDE_PATH="$(STAGING_INSTALL_PREFIX)/include" CMAKE_LIBRARY_PATH="$(STAGING_INSTALL_PREFIX)/lib" PCH_COMPILE_FLAGS="$(CFLAGS)"

include ../../mk/spksrc.cross-cc.mk

.PHONY: domoticz_configure
domoticz_configure:
	$(RUN) cmake CMakeLists.txt

.PHONY: domoticz_install
domoticz_install:
	@mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	@$(RUN) install -m 755 domoticz $(STAGING_INSTALL_PREFIX)/bin
	@$(RUN) cp -R www $(STAGING_INSTALL_PREFIX)
	@$(RUN) cp -R Config $(STAGING_INSTALL_PREFIX)
	@$(RUN) cp -R scripts $(STAGING_INSTALL_PREFIX)
	@mkdir -p $(STAGING_INSTALL_PREFIX)/var

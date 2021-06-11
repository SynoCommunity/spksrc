PKG_NAME = domoticz
PKG_VERS = 2020.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/domoticz/domoticz/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/boost cross/sqlite cross/curl cross/python38 cross/lua cross/zlib
DEPENDS += cross/jsoncpp
DEPENDS += cross/mosquitto
DEPENDS += cross/cereal

# TODO:
# jsoncpp fails for qoriq

HOMEPAGE = https://www.domoticz.com/
COMMENT  = Domoticz is a Home Automation System.
LICENSE  = GPLv3

POST_EXTRACT_TARGET = domoticz_post_extract
INSTALL_TARGET = domoticz_install

BOOST_LIBRARIES = atomic chrono date_time system thread
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

ENV += CMAKE_INCLUDE_PATH="$(STAGING_INSTALL_PREFIX)/include"
ENV += CMAKE_LIBRARY_PATH="$(STAGING_INSTALL_PREFIX)/lib" 
ENV += PCH_COMPILE_FLAGS="$(CFLAGS)"

CMAKE_ARGS += -DUSE_BUILTIN_JSONCPP=no
CMAKE_ARGS += -DUSE_BUILTIN_MQTT=no
CMAKE_ARGS += -DUSE_BUILTIN_SQLITE=no

USE_NATIVE_CMAKE = 1

include ../../mk/spksrc.cross-cmake.mk

.PHONY: domoticz_post_extract
# sub module: load minizip from git
domoticz_post_extract:
	@$(RUN); cd extern; git clone https://github.com/domoticz/minizip.git ./minizip

.PHONY: domoticz_install
domoticz_install:
	install -d $(STAGING_INSTALL_PREFIX)/bin $(STAGING_INSTALL_PREFIX)/var
	install -m 755 $(CMAKE_BUILD_DIR)/domoticz $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(CMAKE_BUILD_DIR)/extern/minizip/libminizip.so $(STAGING_INSTALL_PREFIX)/lib
	@$(RUN) cp -R www $(STAGING_INSTALL_PREFIX)
	@$(RUN) cp -R Config $(STAGING_INSTALL_PREFIX)
	@$(RUN) cp -R scripts $(STAGING_INSTALL_PREFIX)

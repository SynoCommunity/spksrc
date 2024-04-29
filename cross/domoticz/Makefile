PKG_NAME = domoticz
PKG_VERS = 2020.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/domoticz/domoticz/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/boost_1.68 cross/sqlite cross/curl cross/python38 cross/lua cross/zlib
DEPENDS += cross/jsoncpp
DEPENDS += cross/mosquitto
DEPENDS += cross/cereal
DEPENDS += cross/openzwave

HOMEPAGE = https://www.domoticz.com/
COMMENT  = Domoticz is a Home Automation System.
LICENSE  = GPLv3

POST_EXTRACT_TARGET = domoticz_post_extract
PRE_COMPILE_TARGET = domoticz_pre_compile
INSTALL_TARGET = domoticz_install

# for domoticz
BOOST_LIBRARIES = atomic chrono date_time system thread
# for cereal
BOOST_LIBRARIES += serialization
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

ENV += CMAKE_INCLUDE_PATH="$(STAGING_INSTALL_PREFIX)/include"
ENV += CMAKE_LIBRARY_PATH="$(STAGING_INSTALL_PREFIX)/lib" 
ENV += PCH_COMPILE_FLAGS="$(CFLAGS)"

CMAKE_USE_TOOLCHAIN_FILE = OFF

CMAKE_ARGS += -DUSE_BUILTIN_JSONCPP=no
CMAKE_ARGS += -DUSE_BUILTIN_MQTT=no
CMAKE_ARGS += -DUSE_BUILTIN_SQLITE=no
CMAKE_ARGS += -DUSE_STATIC_OPENZWAVE=no

# without this, domoticz does not find some openzwave include files:
ADDITIONAL_CXXFLAGS = -I$(STAGING_INSTALL_PREFIX)/include/openzwave

USE_NATIVE_CMAKE = 1

include ../../mk/spksrc.cross-cmake.mk

.PHONY: domoticz_post_extract
# sub module: load minizip from git
domoticz_post_extract:
	@$(RUN); cd extern; git clone https://github.com/domoticz/minizip.git ./minizip

.PHONY: domoticz_pre_compile
# inject version information
domoticz_pre_compile:
	$(RUN) ; sed -e "s/@_version_@/$(PKG_VERS)/g" \
	             -e "s/@_year_@/$(firstword $(subst ., ,$(PKG_VERS)))/g" \
	             -e "s/@_date_@/$(shell date +'%Y-%m-%d %H:%M:%S')/g" \
	             -i main/domoticz.cpp

.PHONY: domoticz_install
domoticz_install:
	install -d $(STAGING_INSTALL_PREFIX)/bin $(STAGING_INSTALL_PREFIX)/var
	install -m 755 $(CMAKE_BUILD_DIR)/domoticz $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(CMAKE_BUILD_DIR)/extern/minizip/libminizip.so $(STAGING_INSTALL_PREFIX)/lib
	@$(RUN) cp -R www $(STAGING_INSTALL_PREFIX)
	@$(RUN) cp -R Config $(STAGING_INSTALL_PREFIX)
	@$(RUN) cp -R scripts $(STAGING_INSTALL_PREFIX)

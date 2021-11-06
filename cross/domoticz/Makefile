PKG_NAME = domoticz
PKG_VERS = 2021.1
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git-repository
PKG_GIT_HASH = 037a4299fca4d45d9b94b389726cce27c1bee9aa
PKG_DIST_SITE = https://github.com/domoticz/domoticz.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/boost_1.68 cross/sqlite cross/curl cross/python38 cross/lua cross/zlib
DEPENDS += cross/jsoncpp
DEPENDS += cross/mosquitto
DEPENDS += cross/cereal
DEPENDS += cross/openzwave

HOMEPAGE = https://www.domoticz.com/
COMMENT  = Domoticz is a Home Automation System.
LICENSE  = GPLv3

INSTALL_TARGET = domoticz_install
# with "PKG_DOWNLOAD_METHOD = git-repository" each download has different checksums.
CHECKSUM_TARGET = nop

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

include ../../mk/spksrc.common.mk
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
CMAKE_ARGS += -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_C99 -D_GLIBCXX_USE_C99_MATH"
endif

USE_NATIVE_CMAKE = 1

include ../../mk/spksrc.cross-cmake.mk

.PHONY: domoticz_install
domoticz_install:
	install -d $(STAGING_INSTALL_PREFIX)/bin $(STAGING_INSTALL_PREFIX)/var
	install -m 755 $(CMAKE_BUILD_DIR)/domoticz $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(CMAKE_BUILD_DIR)/extern/minizip/libminizip.so $(STAGING_INSTALL_PREFIX)/lib
	tar -cf - --exclude=.gitignore -C $(WORK_DIR)/$(PKG_DIR) dzVents | tar -xf - -C $(STAGING_INSTALL_PREFIX)/bin
	@$(RUN) cp -R www $(STAGING_INSTALL_PREFIX)
	@$(RUN) cp -R Config $(STAGING_INSTALL_PREFIX)
	# install scripts folder to var and create link at original location
	@$(RUN) cp -R scripts $(STAGING_INSTALL_PREFIX)/var
	ln -sf $(STAGING_INSTALL_PREFIX)/var/scripts $(STAGING_INSTALL_PREFIX)/scripts

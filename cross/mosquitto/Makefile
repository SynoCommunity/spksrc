PKG_NAME = mosquitto
PKG_VERS = 2.0.20
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://mosquitto.org/files/source
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/c-ares
DEPENDS += cross/openssl3
DEPENDS += cross/libwebsockets
DEPENDS += cross/cjson

# cross/libwebsockets:
UNSUPPORETED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.mosquitto.org/
COMMENT  = Eclipse Mosquitto is an open source (EPL/EDL licensed) message broker that implements the MQTT protocol versions 5.0, 3.1.1 and 3.1.
LICENSE  = EPL 1.0 and EDL 1.0

CMAKE_ARGS += -DWITH_WEBSOCKETS=ON
CMAKE_ARGS += -DWITH_SRV=ON
CMAKE_ARGS += -DDOCUMENTATION=OFF
CMAKE_USE_TOOLCHAIN_FILE = OFF

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
# use clock_gettime of librt
ADDITIONAL_LDFLAGS += -lrt
endif

include ../../mk/spksrc.cross-cmake.mk

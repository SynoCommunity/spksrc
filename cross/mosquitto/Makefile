PKG_NAME = mosquitto
PKG_VERS = 2.0.14
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://mosquitto.org/files/source
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/c-ares cross/openssl cross/libuuid
DEPENDS += cross/libwebsockets
DEPENDS += cross/cjson

UNSUPPORETED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.mosquitto.org/
COMMENT  = Eclipse Mosquitto is an open source (EPL/EDL licensed) message broker that implements the MQTT protocol versions 5.0, 3.1.1 and 3.1.
LICENSE  = EPL 1.0 and EDL 1.0

CONFIGURE_TARGET = nop

# from README-compiling.md:
# To compile, run "make", but also see the file config.mk for more details on the
# various options that can be compiled in.
COMPILE_MAKE_OPTIONS = WITH_WEBSOCKETS=yes WITH_SRV=yes WITH_DOCS=no

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
# use clock_gettime of librt
ADDITIONAL_LDFLAGS = -lrt 
endif

include ../../mk/spksrc.cross-cc.mk

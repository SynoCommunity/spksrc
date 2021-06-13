PKG_NAME = mosquitto
PKG_VERS = 1.6.15
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://mosquitto.org/files/source
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/c-ares cross/openssl cross/util-linux cross/libwebsockets

UNSUPPORETED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.mosquitto.org/
COMMENT  = Mosquitto is an open source message broker that implements the MQTT protocol versions 5.0, 3.1.1 and 3.1.
LICENSE  = EPL 1.0 and EDL 1.0

CONFIGURE_TARGET = nop

COMPILE_MAKE_OPTIONS = WITH_WEBSOCKETS=yes WITH_SRV=yes WITH_DOCS=no

ifeq ($(findstring $(ARCH), 88f6281),$(ARCH))
# use clock_gettime of librt
ADDITIONAL_LDFLAGS = -lrt 
endif

include ../../mk/spksrc.cross-cc.mk

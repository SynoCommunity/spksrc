PKG_NAME = mosquitto
PKG_VERS = 1.4.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://mosquitto.org/files/source
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/c-ares cross/openssl cross/util-linux cross/libwebsockets

HOMEPAGE = http://www.mosquitto.org/
COMMENT  = Mosquitto is an open source message broker that implements the MQ Telemetry Transport protocol version 3.1.1.
LICENSE  = BSD licensed

CONFIGURE_TARGET = nop

include ../../mk/spksrc.cross-cc.mk

PKG_NAME = mosquitto
PKG_VERS = 1.3.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://mosquitto.org/files/source/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/c-ares cross/openssl

HOMEPAGE = http://www.mosquitto.org/
COMMENT  = Mosquitto is an open source (BSD licensed) message broker that implements the MQ Telemetry Transport protocol version 3.1. MQTT provides a lightweight method of carrying out messaging using a publish/subscribe model. This makes it suitable for "machine to machine" messaging such as with low power sensors or mobile devices such as phones, embedded computers or microcontrollers like the Arduino.
LICENSE  = BSD

CONFIGURE_TARGET = nop

include ../../mk/spksrc.cross-cc.mk


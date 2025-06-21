PKG_NAME = rabbitmq-c
PKG_VERS = 0.15.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/alanxz/rabbitmq-c/archive/refs/tags/
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl3

HOMEPAGE = https://github.com/alanxz/rabbitmq-c
COMMENT  = This is a C-language AMQP client library for use with v2.0+ of the RabbitMQ broker.
LICENSE  = MIT

CMAKE_ARGS  = -DCMAKE_BUILD_TYPE=Release
CMAKE_ARGS += -DBUILD_EXAMPLES=OFF
CMAKE_ARGS += -DBUILD_TESTING=OFF
CMAKE_ARGS += -DBUILD_STATIC_LIBS=OFF

include ../../mk/spksrc.cross-cmake.mk

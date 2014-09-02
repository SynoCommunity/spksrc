PKG_NAME = protobuf-c
PKG_VERS = 1.0.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/protobuf-c/protobuf-c/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/protobuf-c/protobuf-c
COMMENT  = Protocol Buffers implementation in C
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-protoc

include ../../mk/spksrc.cross-cc.mk


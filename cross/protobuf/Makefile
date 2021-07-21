PKG_NAME = protobuf
PKG_VERS = 3.5.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-cpp-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/google/protobuf/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = native/protoc

HOMEPAGE = https://github.com/google/protobuf
COMMENT  = Protocol Buffers implementation in CPP

NATIVE_PROTOC = $(realpath $(WORK_DIR)/../../../native/protoc/work-native/bin/protoc)

GNU_CONFIGURE = 1
CONFIGURE_ARGS = cross_compiling=yes --with-protoc=$(NATIVE_PROTOC)

PRE_COMPILE_TARGET = protobuf_pre_compile

include ../../mk/spksrc.cross-cc.mk

.PHONY: protobuf_pre_compile
# Skip unit tests
protobuf_pre_compile:
	@touch $(WORK_DIR)/$(PKG_DIR)/src/unittest_proto_middleman

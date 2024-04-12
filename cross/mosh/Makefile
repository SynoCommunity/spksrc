PKG_NAME = mosh
PKG_VERS = 1.4.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mobile-shell/mosh/releases/download/$(PKG_NAME)-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncursesw cross/zlib cross/openssl3 cross/protobuf cross/libutempter

HOMEPAGE = https://mosh.org
COMMENT  = Mosh: the mobile shell
LICENSE  = GPLv3+

GNU_CONFIGURE = 1
CONFIGURE_ARGS += --with-utempter

include ../../mk/spksrc.cross-cc.mk

NATIVE_PROTOC_DIR = $(realpath $(WORK_DIR)/../../../native/protoc/work-native)
ENV += PATH=$(NATIVE_PROTOC_DIR)/bin:$$PATH

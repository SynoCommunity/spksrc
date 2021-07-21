PKG_NAME = mosh
PKG_VERS = 1.3.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mobile-shell/mosh/releases/download/$(PKG_NAME)-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/protoc
DEPENDS = cross/zlib cross/openssl cross/protobuf cross/ncurses

HOMEPAGE = https://mosh.org
COMMENT  = Mosh: the mobile shell
LICENSE  = GPLv3+

GNU_CONFIGURE = 1
# avoid warning: _FORTIFY_SOURCE requires compiling with optimization (-O)
ADDITIONAL_CPPFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk

NATIVE_PROTOC_DIR = $(realpath $(WORK_DIR)/../../../native/protoc/work-native)
ENV += PATH=$(NATIVE_PROTOC_DIR)/bin:$$PATH

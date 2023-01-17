PKG_NAME = mosh
PKG_VERS = 1.3.2
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mobile-shell/mosh/releases/download/$(PKG_DIR)

DEPENDS = cross/zlib cross/openssl cross/protobuf cross/ncurses

HOMEPAGE = https://mosh.org
COMMENT  = Mosh: the mobile shell
LICENSE  = GPLv3+

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

ENV += PATH=$(WORK_DIR)/../../../native/protobuf/work-native/install/usr/local/bin/:$$PATH
ENV += LD_LIBRARY_PATH=$(WORK_DIR)/../../../native/protobuf/work-native/install/usr/local/lib:$(LD_LIBRARY_PATH)

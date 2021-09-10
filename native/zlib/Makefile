PKG_NAME = zlib
PKG_VERS = 1.2.11
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://zlib.net
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://zlib.net/
COMMENT  = A Massively Spiffy Yet Delicately Unobtrusive Compression Library.
LICENSE  = zlib-license

NATIVE_CFLAGS  = -I$(realpath $(WORK_DIR)/../../../native/zlib/work-native/install/usr/local/include )
NATIVE_LDFLAGS = -L$(realpath $(WORK_DIR)/../../../native/zlib/work-native/install/usr/local/lib )

CONFIGURE_TARGET = native_zlib_configure
COMPILE_TARGET = native_zlib_compile

include ../../mk/spksrc.native-cc.mk

.PHONY: native_zlib_configure
native_zlib_configure:
	cd $(WORK_DIR)/$(PKG_DIR) ; AR=ar CC=gcc INSTALL_PREFIX=/usr/local ./configure

.PHONY: native_zlib_compile
native_zlib_compile:
	cd $(WORK_DIR)/$(PKG_DIR) ; $(MAKE) $(COMPILE_MAKE_OPTIONS)

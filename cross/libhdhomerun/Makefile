PKG_NAME = libhdhomerun
PKG_VERS = 20231214
PKG_EXT = tgz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.silicondust.com/hdhomerun
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE = https://www.silicondust.com/hdhomerun/
COMMENT = HDHomerun Library
LICENSE = LGPL v2.1

CONFIGURE_TARGET = nop
INSTALL_TARGET = libhdhomerun_install

include ../../mk/spksrc.cross-cc.mk

COMPILE_MAKE_OPTIONS = CROSS_COMPILE=$(abspath $(CURDIR)/../../toolchain/syno-$(ARCH)-$(TCVERSION)/work/$(TC_TARGET)/bin/$(TC_PREFIX))

.PHONY: libhdhomerun_install
libhdhomerun_install:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/include/libhdhomerun
	@install -m 644 $(INSTALL_DIR)/../$(PKG_DIR)/*.h $(STAGING_INSTALL_PREFIX)/include/libhdhomerun/
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(INSTALL_DIR)/../$(PKG_DIR)/hdhomerun_config $(STAGING_INSTALL_PREFIX)/bin/
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/lib
	@install -m 644 $(INSTALL_DIR)/../$(PKG_DIR)/libhdhomerun.so $(STAGING_INSTALL_PREFIX)/lib/

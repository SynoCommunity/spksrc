PKG_NAME = libhdhomerun
PKG_VERS = 20260313
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

# Its Makefile builds the tool names from CROSS_COMPILE, a prefix that assumes the
# compiler is <path>/<target>-gcc and nothing else; ask the toolchain for each tool
# instead of spelling out a path under toolchain/.
COMPILE_ARGS = CC="$(call tc,gcc)" STRIP="$(call tc,strip)"

.PHONY: libhdhomerun_install
libhdhomerun_install:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/include/libhdhomerun
	@install -m 644 $(INSTALL_DIR)/../$(PKG_DIR)/*.h $(STAGING_INSTALL_PREFIX)/include/libhdhomerun/
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(INSTALL_DIR)/../$(PKG_DIR)/hdhomerun_config $(STAGING_INSTALL_PREFIX)/bin/
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/lib
	@install -m 644 $(INSTALL_DIR)/../$(PKG_DIR)/libhdhomerun.so $(STAGING_INSTALL_PREFIX)/lib/

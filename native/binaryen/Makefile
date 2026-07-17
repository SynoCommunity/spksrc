PKG_NAME = binaryen
PKG_VERS = version_124
PKG_EXT = tar.gz
PKG_DIST_NAME = binaryen-$(PKG_VERS)-x86_64-linux.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/WebAssembly/binaryen/releases/download/$(PKG_VERS)
PKG_DIR = binaryen-$(PKG_VERS)

HOMEPAGE = https://github.com/WebAssembly/binaryen
COMMENT  = Binaryen is a compiler and toolchain infrastructure for WebAssembly
LICENSE  = Apache-2.0

INSTALL_TARGET = binaryen_install

include ../../mk/spksrc.native-install.mk

.PHONY: binaryen_install
binaryen_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/bin/* $(STAGING_INSTALL_PREFIX)/bin/

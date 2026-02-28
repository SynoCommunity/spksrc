PKG_NAME = xxd
PKG_VERS = 9.1.0972
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/vim/vim/archive/refs/tags
PKG_DIST_FILE = vim-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = vim-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.vim.org/
COMMENT  = xxd - make a hexdump or do the reverse
LICENSE  = vim

CONFIGURE_TARGET = nop
COMPILE_TARGET = xxd_compile_target
INSTALL_TARGET = xxd_install_target

include ../../mk/spksrc.native-cc.mk

.PHONY: xxd_compile_target
xxd_compile_target:
	cd $(WORK_DIR)/$(PKG_DIR)/src/xxd && cc -DUNIX -o xxd xxd.c

.PHONY: xxd_install_target
xxd_install_target:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/src/xxd/xxd $(STAGING_INSTALL_PREFIX)/bin/xxd

PKG_NAME = msedit
PKG_VERS = 2.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/microsoft/edit/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = edit-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/microsoft/edit
COMMENT  = A simple editor for simple needs. Pays homage to the classic MS-DOS Editor with a modern interface.
LICENSE  = MIT

CARGO_BUILD_ARGS = --locked

RUST_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)/crates/edit

POST_INSTALL_TARGET = msedit_rename

.PHONY: msedit_rename
msedit_rename:
	@$(MSG) Renaming binary from edit to msedit
	mv -f $(STAGING_INSTALL_PREFIX)/bin/edit $(STAGING_INSTALL_PREFIX)/bin/msedit

include ../../mk/spksrc.cross-rust.mk

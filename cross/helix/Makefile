PKG_NAME = helix
PKG_VERS = 24.07
PKG_EXT  = tar.gz
PKG_DIR  = helix-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_DIST_NAME)
PKG_DIST_SITE = https://github.com/helix-editor/helix/archive

HOMEPAGE = https://helix-editor.com/
COMMENT  = A post-modern modal text editor.
LICENSE  = MPL-2.0

CARGO_BUILD_ARGS += --locked
CARGO_BUILD_ARGS += --profile opt

ENV += HELIX_DEFAULT_RUNTIME=/var/packages/$(PKG_NAME)/target/runtime

RUST_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)/helix-term

POST_INSTALL_TARGET = helix_post_install

include ../../mk/spksrc.cross-rust.mk

.PHONY: helix_post_install
helix_post_install:
	rsync -a \
		--exclude ".*" \
		--exclude sources \
		$(WORK_DIR)/$(PKG_DIR)/runtime $(STAGING_INSTALL_PREFIX)/

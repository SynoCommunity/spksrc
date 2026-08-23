PKG_NAME = ms-edit
PKG_REAL_NAME = edit
PKG_VERS = 2.0.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/microsoft/edit/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_REAL_NAME)-$(PKG_VERS)/crates/$(PKG_REAL_NAME)

# Rust Edition 2024 required
MIN_RUSTC_VERSION = 1.85

HOMEPAGE = https://github.com/microsoft/edit/
COMMENT = A simple editor for simple needs.
LICENSE = MIT

CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk

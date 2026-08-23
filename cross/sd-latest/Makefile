PKG_NAME = sd
PKG_VERS = 1.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/chmln/sd/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# Rust Edition 2024 required
MIN_RUSTC_VERSION = 1.85

HOMEPAGE = https://github.com/chmln/sd#readme
COMMENT = Intuitive find & replace CLI (sed alternative).
LICENSE = MIT

CARGO_BUILD_ARGS = --locked
RUST_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)/sd-cli

include ../../mk/spksrc.cross-rust.mk

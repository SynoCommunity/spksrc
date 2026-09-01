PKG_NAME = lsd
PKG_VERS = 1.2.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/lsd-rs/lsd/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# Rust Edition 2024 required
MIN_RUSTC_VERSION = 1.85

HOMEPAGE = https://github.com/lsd-rs/lsd
COMMENT  = The next gen ls command.
LICENSE  = Apache 2.0

CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk

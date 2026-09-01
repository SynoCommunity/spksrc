PKG_NAME = bat
PKG_VERS = 0.26.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/sharkdp/bat/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

# bat >= 0.26.1 declares MSRV 1.87, and locks etcetera 0.11.0 (edition2024)
MIN_RUSTC_VERSION = 1.87

HOMEPAGE = https://github.com/sharkdp/bat
COMMENT = A cat(1) clone with wings.
LICENSE = MIT or Apache 2.0

CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk

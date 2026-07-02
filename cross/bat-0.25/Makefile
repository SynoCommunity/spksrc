PKG_NAME = bat
PKG_VERS = 0.25.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/sharkdp/bat/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# This is the last version that builds for ARMv5 with rust 1.72.2
# bat v0.26.0 requires rustc >= 1.79

DEPENDS = cross/zlib

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://github.com/sharkdp/bat
COMMENT = A cat(1) clone with wings.
LICENSE = MIT or Apache 2.0

CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk

PKG_NAME = dua
PKG_VERS = 2.32.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Byron/dua-cli/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-cli-$(PKG_VERS)

DEPENDS =

# error: failed to compile `dua-cli v2.32.0`: rustc 1.82.0-dev is not supported
# by the following packages: dua-cli@2.32.0 requires rustc 1.83.0
# Every arch whose rustc comes from the from-source overlay is pinned at 1.82,
# which is what the three arch lists this replaces were spelling out one family
# at a time -- plus x86-5.2, which they missed and which failed as soon as
# DSM 5.2 was enabled in CI.
MIN_RUSTC_VERSION = 1.83

CARGO_BUILD_ARGS = --locked

HOMEPAGE = https://lib.rs/crates/dua-cli
COMMENT  = A tool to conveniently learn about the disk usage of directories, fast!
LICENSE  = MIT

include ../../mk/spksrc.cross-rust.mk

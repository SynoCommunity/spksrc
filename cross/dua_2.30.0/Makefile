PKG_NAME = dua
PKG_VERS = 2.30.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Byron/dua-cli/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-cli-$(PKG_VERS)

DEPENDS =

# pipe2 landed in glibc 2.9
MIN_GLIBC_VERSION = 2.9

CARGO_BUILD_ARGS = --locked

HOMEPAGE = https://lib.rs/crates/dua-cli
COMMENT  = A tool to conveniently learn about the disk usage of directories, fast!
LICENSE  = MIT

include ../../mk/spksrc.cross-rust.mk

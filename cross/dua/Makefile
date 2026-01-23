PKG_NAME = dua
PKG_VERS = 2.32.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Byron/dua-cli/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-cli-$(PKG_VERS)

DEPENDS =

# linker error: dwarf version '4' is not supported
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)
# error[E0658]: use of unstable library feature 'iter_repeat_n'
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)
# To build v2.31.0 we need to update rust for qoriq.
# dua 2.31.0 requires rust 1.83.0 (we currently have rust 1.82.0 for qoriq)
UNSUPPORTED_ARCHS += $(PPC_ARCHS)

CARGO_BUILD_ARGS = --locked

HOMEPAGE = https://lib.rs/crates/dua-cli
COMMENT  = A tool to conveniently learn about the disk usage of directories, fast!
LICENSE  = MIT

include ../../mk/spksrc.cross-rust.mk

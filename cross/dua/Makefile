PKG_NAME = dua
PKG_VERS = 2.30.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Byron/dua-cli/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-cli-$(PKG_VERS)

DEPENDS =

# linker error: dwarf version '4' is not supported
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)
# package `home v0.5.11` requires RUSTUP_TOOLCHAIN (rustc) >= 1.81
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

HOMEPAGE = https://lib.rs/crates/dua-cli
COMMENT  = A tool to conveniently learn about the disk usage of directories, fast!
LICENSE  = MIT

include ../../mk/spksrc.cross-rust.mk

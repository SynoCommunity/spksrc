PKG_NAME = dutree
PKG_VERS = 0.2.18
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/nachoparker/dutree/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Reloc 95 is R_PPC_TLSGD, which ld learned in binutils 2.20; ppc853x-5.2 is still on
# 2.18.50 and answers "unknown relocation type 95". The linker is short, not the arch.
MIN_BINUTILS_VERSION = 2.20

DEPENDS =

HOMEPAGE = https://ownyourbits.com/2018/03/25/analyze-disk-usage-with-dutree/
COMMENT  = A tool to analyze file system usage written in Rust.
LICENSE  = GPLv3

CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk

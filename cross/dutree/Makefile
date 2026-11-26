PKG_NAME = dutree
PKG_VERS = 0.2.18
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/nachoparker/dutree/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# The Rust link needs R_PPC_TLSGD (reloc 95), which ld learned in binutils 2.20; the
# binutils overlay brings it where the vendor ld is older (ppc853x-5.2: 2.18.50).
MIN_RUSTC_BINUTILS_VERSION = 2.20

DEPENDS =

HOMEPAGE = https://ownyourbits.com/2018/03/25/analyze-disk-usage-with-dutree/
COMMENT  = A tool to analyze file system usage written in Rust.
LICENSE  = GPLv3

CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk

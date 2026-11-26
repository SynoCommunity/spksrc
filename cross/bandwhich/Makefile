PKG_NAME = bandwhich
PKG_VERS = 0.23.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/imsnif/bandwhich/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# The Rust link needs R_PPC_TLSGD (reloc 95), which ld learned in binutils 2.20; the
# binutils overlay brings it where the vendor ld is older (ppc853x-5.2: 2.18.50).
MIN_RUSTC_BINUTILS_VERSION = 2.20
# Requires 'epoll_create1' and 'pipe2'
MIN_GLIBC_VERSION = 2.9

HOMEPAGE = https://github.com/imsnif/bandwhich#readme
COMMENT  = CLI utility for displaying current network utilization by process, connection and remote IP/hostname.
LICENSE  = MIT

CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk

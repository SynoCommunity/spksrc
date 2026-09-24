PKG_NAME = bandwhich
PKG_VERS = 0.23.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/imsnif/bandwhich/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# Reloc 95 is R_PPC_TLSGD, which ld learned in binutils 2.20; ppc853x-5.2 is still on
# 2.18.50 and answers "unknown relocation type 95". The linker is short, not the arch.
MIN_BINUTILS_VERSION = 2.20

HOMEPAGE = https://github.com/imsnif/bandwhich#readme
COMMENT  = CLI utility for displaying current network utilization by process, connection and remote IP/hostname.
LICENSE  = MIT

CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk

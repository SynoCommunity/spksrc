PKG_NAME = procs
PKG_VERS = 0.12.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/dalance/procs/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# Dwarf Error: found dwarf version '4', this reader only handles version 2 and 3 information.
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://github.com/dalance/procs#readme
COMMENT  = A modern replacement for ps written in Rust.
LICENSE  = MIT

include ../../mk/spksrc.cross-rust.mk

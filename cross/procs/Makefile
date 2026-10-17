PKG_NAME = procs
PKG_VERS = 0.14.10
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/dalance/procs/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# The gate also stood for a binutils limitation, kept here for the record:
#   Dwarf Error: found dwarf version '4', this reader only handles version 2 and 3 information.
# rust's std for this target links against glibc 2.9 wrappers the 2.8 sysroot lacks:
#   undefined reference to `epoll_create1', undefined reference to `pipe2'
MIN_GLIBC_VERSION = 2.9

HOMEPAGE = https://github.com/dalance/procs#readme
COMMENT  = A modern replacement for ps written in Rust.
LICENSE  = MIT

CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk

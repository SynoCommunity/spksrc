PKG_NAME = eza
PKG_VERS = 0.23.4
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/eza-community/eza/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

# pthread_setname_np landed in glibc 2.12
MIN_GLIBC_VERSION = 2.12
# eza 0.23.4 declares MSRV 1.82
MIN_RUSTC_VERSION = 1.82

HOMEPAGE = https://eza.rocks/
COMMENT  = A modern replacement for 'ls'.
LICENSE  = MIT

CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk

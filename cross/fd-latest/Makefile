PKG_NAME = fd
PKG_VERS = 10.5.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/sharkdp/fd/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

MIN_RUSTC_VERSION = 1.90

HOMEPAGE = https://github.com/sharkdp/fd
COMMENT = fd is a program to find entries in your filesystem. It is a simple, fast and user-friendly alternative to find. While it does not aim to support all of find's powerful functionality, it provides sensible (opinionated) defaults for a majority of use cases.
LICENSE = Apache 2.0 / MIT

CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk

PKG_NAME = fd
PKG_VERS = 10.3.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/sharkdp/fd/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# tikv-jemalloc-sys fails to build:
MIN_BINUTILS_VERSION = 2.22

# see: https://github.com/sharkdp/fd/issues/1428
# fd >= 10.5.0 and rustc >= 1.90 fixed the build with ARMv7L toolchain.
#
# No MIN_*_VERSION expresses this one: what this tier cannot serve is an ISA, and the fix
# lives in a NEWER fd, so a floor would have to be a ceiling. Hence the arch list, with
# the reason pre-check.mk asks of whoever adds one.
UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS)
UNSUPPORTED_ARCHS_REASON := fd < 10.5.0 does not build for the ARMv7L toolchain

HOMEPAGE = https://github.com/sharkdp/fd
COMMENT  = fd is a program to find entries in your filesystem. It is a simple, fast and user-friendly alternative to find. While it does not aim to support all of find's powerful functionality, it provides sensible (opinionated) defaults for a majority of use cases.
LICENSE  = Apache 2.0 / MIT

CARGO_BUILD_ARGS = --locked --verbose

include ../../mk/spksrc.cross-rust.mk

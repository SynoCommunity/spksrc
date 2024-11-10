PKG_NAME = fd
PKG_VERS = 8.7.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/sharkdp/fd/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# PKG_VERS = 8.7.1 fails to build for RUST_TARGET = armv7-unknown-linux-gnueabi $(ARMv7L_ARCHS)
# PKG_VERS <= 8.7.0 fails with newer rustc 1.80.1 - rust version to 1.77.2 for hi3535
# see: https://github.com/sharkdp/fd/issues/1428

# powerpc archs (except qoriq) are not supported
# undefined reference to 'pipe2'
UNSUPPORTED_ARCHS += $(OLD_PPC_ARCHS)

include ../../mk/spksrc.archs.mk
# issue with ARMv5: https://github.com/sharkdp/fd/issues/1049#issue-1283491635
# workaround for: https://github.com/rust-lang/compiler-builtins/issues/420
# fix documented in comment: https://github.com/rust-lang/compiler-builtins/issues/420#issuecomment-1335159456
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
ENV += RUSTFLAGS="-Clink-arg=-Wl,--allow-multiple-definition"
endif

HOMEPAGE = https://github.com/sharkdp/fd
COMMENT  = fd is a program to find entries in your filesystem. It is a simple, fast and user-friendly alternative to find. While it does not aim to support all of find's powerful functionality, it provides sensible (opinionated) defaults for a majority of use cases.
LICENSE  = Apache 2.0 / MIT

include ../../mk/spksrc.cross-rust.mk

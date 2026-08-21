PKG_NAME = fd-main

OPTIONAL_DEPENDS  = cross/fd-latest
OPTIONAL_DEPENDS += cross/fd-10.3

# PKG_VERS >= 8.7.1 fails to build for RUST_TARGET = armv7-unknown-linux-gnueabi $(ARMv7L_ARCHS)
# PKG_VERS <= 8.7.0 fails with newer rustc 1.80.1
# see: https://github.com/sharkdp/fd/issues/1428
# we can no longer downgrade to rust 1.77.2 for ARMv7L to build fd 8.7.0
UNSUPPORTED_ARCHS = $(ARMv7L_ARCHS)
# pipe2 landed in glibc 2.9
MIN_GLIBC_VERSION = 2.9
# issues with atomic library
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)


CARGO_BUILD_ARGS = --locked --verbose

include ../../mk/spksrc.cross-rust.mk
include ../../mk/spksrc.cross-virtual.mk

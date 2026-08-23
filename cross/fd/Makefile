PKG_NAME = fd-virtual

OPTIONAL_DEPENDS  = cross/fd-latest
OPTIONAL_DEPENDS += cross/fd-10.3

# tikv-jemalloc-sys fails to build:
UNSUPPORTED_ARCH = $(OLD_PPC_ARCHS)
# PKG_VERS >= 8.7.1 fails to build for RUST_TARGET = armv7-unknown-linux-gnueabi $(ARMv7L_ARCHS)
# PKG_VERS <= 8.7.0 fails with rustc >= 1.80.1
# see: https://github.com/sharkdp/fd/issues/1428
# we can no longer downgrade to rust 1.77.2 for ARMv7L to build fd 8.7.0
UNSUPPORTED_ARCHS = $(ARMv7L_ARCHS)

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge,$(TC_RUSTC),1.85),1)
DEPENDS = cross/fd-latest
else
DEPENDS = cross/fd-10.3
endif

include ../../mk/spksrc.cross-virtual.mk

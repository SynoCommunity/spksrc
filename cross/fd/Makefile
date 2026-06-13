PKG_NAME = fd-main

OPTIONAL_DEPENDS  = cross/fd-latest
OPTIONAL_DEPENDS += cross/fd-10.3

# PKG_VERS >= 8.7.1 fails to build for RUST_TARGET = armv7-unknown-linux-gnueabi $(ARMv7L_ARCHS)
# PKG_VERS <= 8.7.0 fails with newer rustc 1.80.1
# see: https://github.com/sharkdp/fd/issues/1428
# we can no longer downgrade to rust 1.77.2 for ARMv7L to build fd 8.7.0
UNSUPPORTED_ARCHS = $(ARMv7L_ARCHS)
# powerpc archs (except qoriq) are not supported
# undefined reference to 'pipe2'
UNSUPPORTED_ARCHS += $(OLD_PPC_ARCHS)
# issues with atomic library
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
# latest version that builds for qoriq with rustc 1.87.0 (version 10.4.x requires rustc 1.90.0)
DEPENDS = cross/fd-10.3
else
DEPENDS = cross/fd-latest
endif

include ../../mk/spksrc.main-depends.mk

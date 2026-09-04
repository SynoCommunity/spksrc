PKG_NAME = fd-virtual

OPTIONAL_DEPENDS  = cross/fd-latest
OPTIONAL_DEPENDS += cross/fd-10.3

# tikv-jemalloc-sys fails to build:
UNSUPPORTED_ARCH = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge,$(TC_RUSTC),1.85),1)
DEPENDS = cross/fd-latest
else
DEPENDS = cross/fd-10.3
endif

include ../../mk/spksrc.cross-virtual.mk

PKG_NAME = eza-virtual

OPTIONAL_DEPENDS  = cross/eza-latest
OPTIONAL_DEPENDS += cross/eza-0.20.18

# pthread_setname_np landed in glibc 2.12 (both variants)
MIN_GLIBC_VERSION = 2.12

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge,$(TC_RUSTC),1.82),1)
DEPENDS = cross/eza-latest
else
DEPENDS = cross/eza-0.20.18
endif

include ../../mk/spksrc.cross-virtual.mk

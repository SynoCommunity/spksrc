PKG_NAME = bat-virtual

OPTIONAL_DEPENDS  = cross/bat-latest
OPTIONAL_DEPENDS += cross/bat-0.25

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge,$(TC_RUSTC),1.87),1)
DEPENDS = cross/bat-latest
else
DEPENDS = cross/bat-0.25
endif

include ../../mk/spksrc.cross-virtual.mk

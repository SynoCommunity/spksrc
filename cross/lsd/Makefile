PKG_NAME = lsd-virtual

OPTIONAL_DEPENDS  = cross/lsd-latest
OPTIONAL_DEPENDS += cross/lsd-1.1

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge,$(TC_RUSTC),1.85),1)
DEPENDS = cross/lsd-latest
else
DEPENDS = cross/lsd-1.1
endif

include ../../mk/spksrc.cross-virtual.mk

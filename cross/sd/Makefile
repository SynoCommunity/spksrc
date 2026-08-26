PKG_NAME = sd-virtual

OPTIONAL_DEPENDS  = cross/sd-latest
OPTIONAL_DEPENDS += cross/sd-1.0

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge,$(TC_RUSTC),1.85),1)
DEPENDS = cross/sd-latest
else
DEPENDS = cross/sd-1.0
endif

include ../../mk/spksrc.cross-virtual.mk

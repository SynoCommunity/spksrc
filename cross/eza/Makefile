PKG_NAME = eza-virtual

OPTIONAL_DEPENDS  = cross/eza-latest
OPTIONAL_DEPENDS += cross/eza-0.23.4
OPTIONAL_DEPENDS += cross/eza-0.20.18

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge,$(TC_RUSTC),1.85),1)
DEPENDS = cross/eza-latest
else ifeq ($(call version_ge,$(TC_RUSTC),1.82),1)
DEPENDS = cross/eza-0.23.4
else
DEPENDS = cross/eza-0.20.18
endif

include ../../mk/spksrc.cross-virtual.mk

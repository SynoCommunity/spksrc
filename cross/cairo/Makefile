PKG_NAME = cairo-virtual

OPTIONAL_DEPENDS  = cross/cairo-latest
OPTIONAL_DEPENDS += cross/cairo-1.16

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge, $(TC_GCC), 4.8),1)
DEPENDS = cross/cairo-latest
else
DEPENDS = cross/cairo-1.16
endif

include ../../mk/spksrc.cross-virtual.mk

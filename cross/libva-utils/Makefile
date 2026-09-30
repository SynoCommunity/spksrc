PKG_NAME = libva-utils-virtual

OPTIONAL_DEPENDS  = cross/libva-utils-latest
OPTIONAL_DEPENDS += cross/libva-utils-2.17

include ../../mk/spksrc.common.mk

# Same generation as the libva it goes with (cross/libva)
ifeq ($(call version_ge, $(TC_GCC), 5),1)
DEPENDS = cross/libva-utils-latest
else
DEPENDS = cross/libva-utils-2.17
endif

include ../../mk/spksrc.cross-virtual.mk

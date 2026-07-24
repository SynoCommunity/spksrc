PKG_NAME = libvpx-virtual

OPTIONAL_DEPENDS  = cross/libvpx-latest
OPTIONAL_DEPENDS += cross/libvpx-1.14

MIN_GCC_VERSION = 4.6

include ../../mk/spksrc.common.mk

# GCC >= 7.5 (DSM >= 7.0)
ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
DEPENDS = cross/libvpx-latest
else
DEPENDS = cross/libvpx-1.14
endif

include ../../mk/spksrc.cross-virtual.mk

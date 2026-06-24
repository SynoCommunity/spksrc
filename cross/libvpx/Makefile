PKG_NAME = libvpx-main

OPTIONAL_DEPENDS  = cross/libvpx-latest
OPTIONAL_DEPENDS += cross/libvpx-1.14

include ../../mk/spksrc.common.mk

# GCC >= 5 (DSM >= 7.0)
ifeq ($(call version_ge, $(TC_GCC), 5),1)
DEPENDS = cross/libvpx-latest
else
DEPENDS = cross/libvpx-1.14
endif

include ../../mk/spksrc.main-depends.mk

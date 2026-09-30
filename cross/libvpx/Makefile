PKG_NAME = libvpx-virtual

OPTIONAL_DEPENDS  = cross/libvpx-latest
OPTIONAL_DEPENDS += cross/libvpx-1.14

MIN_GCC_VERSION = 4.6

include ../../mk/spksrc.common.mk

# DSM >= 7.0, as the gcc floor it replaces already meant: 1.16 wants more than a modern
# compiler -- its configure refuses the 5.2 and 6.2.4 toolchains outright.
ifeq ($(call version_ge, $(TCVERSION), 7),1)
DEPENDS = cross/libvpx-latest
else
DEPENDS = cross/libvpx-1.14
endif

include ../../mk/spksrc.cross-virtual.mk

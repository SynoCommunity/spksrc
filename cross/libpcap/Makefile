PKG_NAME = libpcap-virtual

OPTIONAL_DEPENDS  = cross/libpcap-latest
OPTIONAL_DEPENDS += cross/libpcap-1.9

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
DEPENDS = cross/libpcap-1.9
else
DEPENDS = cross/libpcap-latest
endif

include ../../mk/spksrc.cross-virtual.mk

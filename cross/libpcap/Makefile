PKG_NAME = libpcap-main

OPTIONAL_DEPENDS  = cross/libpcap-latest
OPTIONAL_DEPENDS += cross/libpcap-1.10.4

# latest version for OLD_PPC_ARCHS is 1.9.1
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.main-depends.mk

ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
DEPENDS = cross/libpcap-1.10.4
else
DEPENDS = cross/libpcap-latest
endif

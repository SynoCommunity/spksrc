PKG_NAME = nmap-main

OPTIONAL_DEPENDS  = cross/nmap-latest
OPTIONAL_DEPENDS += cross/nmap-7.98
OPTIONAL_DEPENDS += cross/nmap-7.92

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS = cross/nmap-7.92
else ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
DEPENDS = cross/nmap-7.98
else
DEPENDS = cross/nmap-latest
endif

include ../../mk/spksrc.main-depends.mk

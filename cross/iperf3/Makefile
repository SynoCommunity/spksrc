PKG_NAME = iperf3-main

# libatomics is required for iperf3 >= 3.16
OPTIONAL_DEPENDS  = cross/iperf3-latest
OPTIONAL_DEPENDS += cross/iperf3-3.15

include ../../mk/spksrc.main-depends.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5_ARCHS)),$(ARCH))
DEPENDS = cross/iperf3-3.15
else
DEPENDS = cross/iperf3-latest
endif

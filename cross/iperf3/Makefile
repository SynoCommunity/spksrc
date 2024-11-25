PKG_NAME = iperf3-main

# libatomics is required for iperf3 >= 3.16
OPTIONAL_DEPENDS  = cross/iperf3-latest
OPTIONAL_DEPENDS += cross/iperf3-3.15

include ../../mk/spksrc.main-depends.mk

ifeq ($(call version_lt, ${TCVERSION}, 6.0)$(call version_ge, ${TCVERSION}, 3.0),11)
DEPENDS = cross/iperf3-3.15
else ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
DEPENDS = cross/iperf3-3.15
else
DEPENDS = cross/iperf3-latest
endif

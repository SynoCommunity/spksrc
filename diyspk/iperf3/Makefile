SPK_NAME = iperf3
SPK_VERS = 3.17.1
SPK_REV = 1
SPK_ICON = src/iperf3.png

DEPENDS = cross/iperf3

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5_ARCHS)),$(ARCH))
SPK_VERS = 3.15
endif


MAINTAINER = hgy59
DESCRIPTION = The iperf series of tools perform active measurements to determine the maximum achievable bandwidth on IP networks. It supports tuning of various parameters related to timing, protocols, and buffers. For each test it reports the measured throughput, loss, and other parameters.
DISPLAY_NAME = iperf3
STARTABLE = no

HOMEPAGE = https://iperf.fr/
LICENSE = 3-clause BSD

SPK_COMMANDS = bin/iperf3

include ../../mk/spksrc.spk.mk

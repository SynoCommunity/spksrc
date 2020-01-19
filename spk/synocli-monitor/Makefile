SPK_NAME = synocli-monitor
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/synocli-monitor.png

DEPENDS = cross/nmon cross/iperf2 cross/iperf3

OPTIONAL_DESC =

# provide htop until DSM 5.2 (DSM >=6 already have htop)
ifeq (5,$(firstword $(sort $(TCVERSION) 5.2)))
DEPENDS += cross/htop
OPTIONAL_DESC += "htop, "
endif

ifeq ($(OPTIONAL_DESC),)
OPTIONAL_DESC = " "
endif

MAINTAINER = SynoCommunity
DESCRIPTION = SynoCli Monitor Tools provides a set of command-line utilities for system monitoring: nmon, iperf2, iperf3,$(OPTIONAL_DESC)lsof.
DISPLAY_NAME = SynoCli Monitor Tools
STARTABLE = no
CHANGELOG = "Initial release"

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliMonitor
LICENSE  = Each tool is licensed under it\'s respective license.

SERVICE_SETUP = src/service-setup.sh


include ../../mk/spksrc.spk.mk

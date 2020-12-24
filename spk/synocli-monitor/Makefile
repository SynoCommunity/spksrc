SPK_NAME = synocli-monitor
SPK_VERS = 1.0
SPK_REV = 2
SPK_ICON = src/synocli-monitor.png

DEPENDS = cross/nmon cross/iperf2 cross/iperf3 cross/busybox cross/htop
OPTIONAL_DEPENDS = cross/htop

OPTIONAL_DESC =

BUSYBOX_CONFIG = procutils

# include process utilities not contained in DSM<6 and DSM>2 (pstree)
ifneq (6, $(firstword $(sort $(TCVERSION) 6)))
ifeq (6, $(firstword $(sort $(TCVERSION) 2)))
BUSYBOX_CONFIG += procutils.dsm5
OPTIONAL_DESC := $(OPTIONAL_DESC)", and process utilities \(lsof, iostat, pgrep, pmap, watch\)"
endif
endif


MAINTAINER = SynoCommunity
DESCRIPTION = SynoCli Monitor Tools provides a set of command-line utilities for system monitoring: nmon, iperf2, iperf3, htop$(OPTIONAL_DESC).
DISPLAY_NAME = SynoCli Monitor Tools
STARTABLE = no
CHANGELOG = "1. Update htop to 3.0.2 and include it in all DSM versions.<br/>2. Update iperf3 to 3.9 and openssl to 1.1."

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliMonitor
LICENSE  = Each tool is licensed under it\'s respective license.

SERVICE_SETUP = src/service-setup.sh

ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

SPK_COMMANDS  = bin/htop bin/nmon bin/iperf2 bin/iperf3 bin/lsof
SPK_COMMANDS += bin/iostat bin/lsof bin/pgrep bin/pmap bin/watch bin/pstree

include ../../mk/spksrc.spk.mk

SPK_NAME = synocli-monitor
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/synocli-monitor.png

DEPENDS = cross/nmon cross/iperf2 cross/iperf3 cross/busybox
OPTIONAL_DEPENDS = cross/htop

OPTIONAL_DESC =

# provide htop until DSM 5.0 (later versions already have htop)
ifneq (5.1,$(firstword $(sort $(TCVERSION) 5.1)))
DEPENDS += cross/htop
OPTIONAL_DESC := $(OPTIONAL_DESC)", htop"
endif

BUSYBOX_CONFIG = procutils

# include process utilities not contained in DSM<6 (pstree)
ifneq (6, $(firstword $(sort $(TCVERSION) 6)))
BUSYBOX_CONFIG += procutils.dsm5
endif


MAINTAINER = SynoCommunity
DESCRIPTION = SynoCli Monitor Tools provides a set of command-line utilities for system monitoring: nmon, iperf2, iperf3$(OPTIONAL_DESC) and process utilities \(lsof, iostat, pgrep, pmap, watch\).
DISPLAY_NAME = SynoCli Monitor Tools
STARTABLE = no
CHANGELOG = "Initial release"

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliMonitor
LICENSE  = Each tool is licensed under it\'s respective license.

SERVICE_SETUP = src/service-setup.sh

ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

SPK_COMMANDS  = bin/htop bin/nmon bin/iperf2 bin/iperf3 bin/lsof
SPK_COMMANDS += bin/iostat bin/lsof bin/pgrep bin/pmap bin/watch bin/pstree


include ../../mk/spksrc.spk.mk

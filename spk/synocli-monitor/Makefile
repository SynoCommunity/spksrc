SPK_NAME = synocli-monitor
SPK_VERS = 1.2
SPK_REV = 4
SPK_ICON = src/synocli-monitor.png

DEPENDS = cross/nmon cross/iperf2 cross/iperf3 cross/busybox cross/htop

BUSYBOX_CONFIG = procutils
OPTIONAL_DESC = ", and process utilities \(lsof, iostat, pgrep, pmap, watch\)"

# include process utilities including pstree for DSM<6 and DSM>2
include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, ${TCVERSION}, 6.0),1)
ifeq ($(call version_gt, ${TCVERSION}, 2.0),1)
BUSYBOX_CONFIG = procutils.dsm5
OPTIONAL_DESC = ", and process utilities \(lsof, iostat, pgrep, pmap, pstree, watch\)"
endif
endif

BUSYBOX_CONFIG += ionice


MAINTAINER = SynoCommunity
DESCRIPTION = SynoCli Monitor Tools provides a set of command-line utilities for system monitoring: nmon, iperf2, iperf3, htop, ionice$(OPTIONAL_DESC).
DISPLAY_NAME = SynoCli Monitor Tools
STARTABLE = no
CHANGELOG = "1. Add ionice.<br/>2. Update openssl to v1.1.1l.<br/>3. Update iperf2 to v2.1.4.<br/>4. Update htop to v3.1.1."

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliMonitor
LICENSE  = Each tool is licensed under it\'s respective license.

SERVICE_SETUP = src/service-setup.sh

ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

SPK_COMMANDS  = bin/htop bin/nmon bin/iperf2 bin/iperf3
SPK_COMMANDS += bin/ionice
SPK_COMMANDS += bin/iostat bin/lsof bin/pgrep bin/pmap bin/watch bin/pstree

include ../../mk/spksrc.spk.mk

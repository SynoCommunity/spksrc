SPK_NAME = synocli-monitor
SPK_VERS = 1.8
SPK_REV = 12
SPK_ICON = src/synocli-monitor.png

DEPENDS  = cross/nmon cross/njmon
DEPENDS += cross/iperf2 cross/iperf3
DEPENDS += cross/busybox
DEPENDS += cross/ionice
DEPENDS += cross/lsof
DEPENDS += cross/htop
DEPENDS += cross/cpulimit
DEPENDS += cross/net-snmp
DEPENDS += cross/lm-sensors

OPTIONAL_DEPENDS  = cross/bandwhich cross/bottom cross/bottom_0.10 cross/procs
OPTIONAL_DEPENDS += cross/btop

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt,${TCVERSION},6.0)$(call version_gt,${TCVERSION},2.0),11)
# include process utilities including pstree for DSM<6 and DSM>2
BUSYBOX_CONFIG = procutils.dsm5
OPTIONAL_DESC = ", and process utilities \(lsof, iostat, pgrep, pmap, pstree, watch\)"
else
BUSYBOX_CONFIG = procutils
OPTIONAL_DESC = ", and process utilities \(lsof, iostat, pgrep, pmap, watch\)"
endif
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
OPTIONAL_DESC := $(OPTIONAL_DESC)", bandwhich, bottom, procs"
DEPENDS += cross/bandwhich cross/procs
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
DEPENDS += cross/bottom_0.10
else
DEPENDS += cross/bottom
endif
endif

ifneq ($(findstring $(ARCH),$(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
OPTIONAL_DESC := $(OPTIONAL_DESC)", btop"
DEPENDS += cross/btop
endif

MAINTAINER = hgy59
DESCRIPTION = SynoCli Monitor Tools provides a set of command-line utilities for system monitoring: nmon, njmon, iperf2, iperf3, htop, ionice, cpulimit, net-snmp tools$(OPTIONAL_DESC).
DISPLAY_NAME = SynoCli Monitor Tools
STARTABLE = no
CHANGELOG = "1. Add btop 1.4.5."

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliMonitor
LICENSE  = Each tool is licensed under it\'s respective license.

SERVICE_SETUP = src/service-setup.sh

SPK_COMMANDS  = bin/htop
SPK_COMMANDS += bin/nmon bin/njmon
SPK_COMMANDS += bin/iperf2 bin/iperf3
SPK_COMMANDS += bin/ionice
SPK_COMMANDS += bin/iostat bin/pgrep bin/pmap bin/watch bin/pstree
SPK_COMMANDS += bin/lsof
SPK_COMMANDS += bin/cpulimit
SPK_COMMANDS += bin/bandwhich
SPK_COMMANDS += bin/btm
SPK_COMMANDS += bin/procs
SPK_COMMANDS += bin/snmpget bin/snmpgetnext bin/snmpbulkget bin/snmpwalk bin/snmpbulkwalk bin/snmpdelta bin/snmpdf
SPK_COMMANDS += bin/snmpinform bin/snmpnetstat bin/snmpps bin/snmpstatus bin/snmptable bin/snmptest bin/snmptranslate
SPK_COMMANDS += bin/sensors bin/sensors-conf-convert sbin/fancontrol sbin/sensors-detect
SPK_COMMANDS += bin/btop

include ../../mk/spksrc.spk.mk

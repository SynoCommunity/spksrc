SPK_NAME = procutils
SPK_VERS = 1.35.0
SPK_REV = 1

# procutils of busybox, according to synocli-monitor package
DEPENDS = cross/busybox

MAINTAINER = SynoCommunity
STARTABLE = no
SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt,${TCVERSION},6.0)$(call version_gt,${TCVERSION},2.0),11)
# include process utilities including pstree for DSM<6 and DSM>2
BUSYBOX_CONFIG = procutils.dsm5
DESCRIPTION = "busybox process utilities \(iostat, pgrep, pmap, pstree, watch\)"
SPK_COMMANDS = bin/iostat bin/pgrep bin/pmap bin/pstree bin/watch
else
BUSYBOX_CONFIG = procutils
DESCRIPTION = "busybox process utilities \(iostat, pgrep, pmap, watch\)"
SPK_COMMANDS = bin/iostat bin/pgrep bin/pmap bin/watch
endif

ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

HOMEPAGE = https://busybox.net
LICENSE  = GPL

include ../../mk/spksrc.spk.mk

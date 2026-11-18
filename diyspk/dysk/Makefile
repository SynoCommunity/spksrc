SPK_NAME = dysk
SPK_REV = 1

include ../../mk/spksrc.common.mk

DEPENDS = cross/dysk

# SPK_VERS has to follow whichever variant the virtual lands on
ifeq ($(call version_ge,$(TC_RUSTC),1.85),1)
SPK_VERS = 3.8.2
else
SPK_VERS = 3.6.1
endif

MAINTAINER = SynoCommunity
DESCRIPTION = A linux utility to get information on filesystems, like df but better.
DISPLAY_NAME = dysk
STARTABLE = no

HOMEPAGE = https://dystroy.org/dysk/
LICENSE = MIT

SPK_COMMANDS = bin/dysk

include ../../mk/spksrc.spk.mk

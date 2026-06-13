SPK_NAME = sshfs
SPK_VERS = 3.7.6
SPK_REV = 1

DEPENDS = cross/sshfs

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt,${TCVERSION},6.0)$(call version_ge,${TCVERSION},3.0),11)
# DSM 3.x - 5.x
SPK_VERS = 2.10
else ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
# qoriq DSM 6.x
SPK_VERS = 2.10
else ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
SPK_VERS = 3.7.3
endif

MAINTAINER = SynoCommunity
DESCRIPTION = sshfs is a network filesystem client to connect to SSH servers.
DISPLAY_NAME = sshfs
STARTABLE = no

HOMEPAGE = https://github.com/libfuse/sshfs
LICENSE = GPLv2

SPK_COMMANDS = bin/sshfs

include ../../mk/spksrc.spk.mk

SPK_NAME = bat
SPK_VERS = 0.26.1
SPK_REV = 1

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

DEPENDS = cross/bat

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
SPK_VERS = 0.25.0
endif

MAINTAINER = SynoCommunity
DESCRIPTION = A cat(1) clone with wings.
STARTABLE = no

HOMEPAGE = https://github.com/sharkdp/bat
LICENSE = MIT or Apache 2.0

SPK_COMMANDS = bin/bat

include ../../mk/spksrc.spk.mk

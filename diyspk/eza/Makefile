SPK_NAME = eza
SPK_VERS = 0.23.5
SPK_REV = 1

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

DEPENDS = cross/eza

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
SPK_VERS = 0.20.18
else ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
SPK_VERS = 0.23.4
endif

MAINTAINER = SynoCommunity
DESCRIPTION = A modern replacement for 'ls'.
STARTABLE = no

HOMEPAGE = https://eza.rocks/
LICENSE = MIT

SPK_COMMANDS = bin/eza

include ../../mk/spksrc.spk.mk

SPK_NAME = eza
SPK_VERS = 0.23.4
SPK_REV = 1

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
DEPENDS = cross/eza_0.20.18
SPK_VERS = 0.20.18
else
DEPENDS = cross/eza
endif

MAINTAINER = SynoCommunity
DESCRIPTION = A modern replacement for 'ls'.
STARTABLE = no

HOMEPAGE = https://eza.rocks/
LICENSE  = MIT

SPK_COMMANDS = bin/eza

include ../../mk/spksrc.spk.mk

SPK_NAME = lsd
SPK_VERS = 1.2.0
SPK_REV = 1

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

DEPENDS = cross/lsd

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
SPK_VERS = 1.1.5
endif

MAINTAINER = SynoCommunity
DESCRIPTION = The next gen ls command.
STARTABLE = no

HOMEPAGE = https://github.com/lsd-rs/lsd
LICENSE = Apache 2.0

SPK_COMMANDS = bin/lsd

include ../../mk/spksrc.spk.mk

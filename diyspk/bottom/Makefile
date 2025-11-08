SPK_NAME = bottom
SPK_VERS = 0.11.2
SPK_REV = 1

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
DEPENDS = cross/bottom_0.10
SPK_VERS = 0.10.2
else
DEPENDS = cross/bottom
endif


MAINTAINER = SynoCommunity
DESCRIPTION = A customizable cross-platform graphical process/system monitor for the terminal.
STARTABLE = no

HOMEPAGE = https://clementtsang.github.io/bottom
LICENSE  = MIT

SPK_COMMANDS = bin/btm

include ../../mk/spksrc.spk.mk

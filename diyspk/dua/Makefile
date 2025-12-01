SPK_NAME = dua
SPK_VERS = 2.32.0
SPK_REV = 1

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.common.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
SPK_VERS = 2.30.0
DEPENDS = cross/dua_2.30.0
else
DEPENDS = cross/dua
endif

MAINTAINER = SynoCommunity
DESCRIPTION = A tool to conveniently learn about the disk usage of directories, fast!
STARTABLE = no

HOMEPAGE = https://lib.rs/crates/dua-cli
LICENSE  = MIT

SPK_COMMANDS = bin/dua

include ../../mk/spksrc.spk.mk

SPK_NAME = dua
SPK_REV = 1

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

include ../../mk/spksrc.common.mk

DEPENDS = cross/dua

# SPK_VERS has to follow whichever variant the virtual lands on
ifeq ($(call version_ge,$(TC_RUSTC),1.83),1)
SPK_VERS = 2.32.0
else
SPK_VERS = 2.30.0
endif

MAINTAINER = SynoCommunity
DESCRIPTION = A tool to conveniently learn about the disk usage of directories, fast!
STARTABLE = no

HOMEPAGE = https://lib.rs/crates/dua-cli
LICENSE  = MIT

SPK_COMMANDS = bin/dua

include ../../mk/spksrc.spk.mk

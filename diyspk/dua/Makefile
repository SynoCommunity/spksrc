SPK_NAME = dua
SPK_VERS = 2.32.0
SPK_REV = 1

include ../../mk/spksrc.common.mk

DEPENDS = cross/dua

# the virtual falls back to cross/dua-2.30 where 2.32.0's rustc floor is not met,
# and SPK_VERS has to follow it
ifneq ($(call version_ge,$(TC_RUSTC),1.83),1)
SPK_VERS = 2.30.0
endif

MAINTAINER = SynoCommunity
DESCRIPTION = A tool to conveniently learn about the disk usage of directories, fast!
STARTABLE = no

HOMEPAGE = https://lib.rs/crates/dua-cli
LICENSE  = MIT

SPK_COMMANDS = bin/dua

include ../../mk/spksrc.spk.mk

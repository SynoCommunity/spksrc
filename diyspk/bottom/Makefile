SPK_NAME = bottom
SPK_VERS = 0.11.4
SPK_REV = 1

include ../../mk/spksrc.common.mk
# see spk/synocli-monitor: 0.11.4 needs cargo >= 1.85 for edition2024
ifneq ($(call version_ge,$(TC_RUSTC),1.85),1)
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

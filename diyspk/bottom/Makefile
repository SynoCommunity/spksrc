SPK_NAME = bottom
SPK_REV = 1

include ../../mk/spksrc.common.mk

DEPENDS = cross/bottom

# SPK_VERS has to follow whichever variant the virtual lands on
ifeq ($(call version_ge,$(TC_RUSTC),1.85),1)
SPK_VERS = 0.11.4
else
SPK_VERS = 0.10.2
endif

MAINTAINER = SynoCommunity
DESCRIPTION = A customizable cross-platform graphical process/system monitor for the terminal.
STARTABLE = no

HOMEPAGE = https://clementtsang.github.io/bottom
LICENSE  = MIT

SPK_COMMANDS = bin/btm

include ../../mk/spksrc.spk.mk

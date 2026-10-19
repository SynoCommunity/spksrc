SPK_NAME = screen
SPK_REV = 1

include ../../mk/spksrc.common.mk

DEPENDS = cross/screen

# SPK_VERS has to follow whichever variant the virtual lands on
ifeq ($(call version_ge,$(TC_GCC),8),1)
SPK_VERS = 5.0.2
else
SPK_VERS = 4.9.1
endif

MAINTAINER = SynoCommunity
DESCRIPTION = Screen is a full-screen window manager that multiplexes a physical terminal between several processes, typically interactive shells.
DISPLAY_NAME = screen
STARTABLE = no

HOMEPAGE = https://www.gnu.org/software/screen/
LICENSE = GPLv2

SPK_COMMANDS = bin/screen

include ../../mk/spksrc.spk.mk

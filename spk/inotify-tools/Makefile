SPK_NAME = inotify-tools
SPK_VERS = 4.25.9.0
SPK_REV = 4
SPK_ICON = src/inotify-tools.png

DEPENDS = cross/inotify-tools

# archs/toolchains lacking support for fanotify
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS)


MAINTAINER = cyc1ingsir
DESCRIPTION = inotify-tools is a C library and a set of command-line programs for Linux providing a simple interface to inotify.

DISPLAY_NAME = inotify-tools
STARTABLE = no

CHANGELOG = "Update inotify-tools to 4.25.9.0."

HOMEPAGE = https://github.com/inotify-tools/inotify-tools/
LICENSE  = GPLv2

SPK_COMMANDS = bin/inotifywait bin/inotifywatch

include ../../mk/spksrc.spk.mk

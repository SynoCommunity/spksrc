SPK_NAME = inotify-tools
SPK_VERS = 3.20.2
SPK_REV = 1
SPK_ICON = src/inotifytools.png

MAINTAINER = cyc1ingsir

include ../../mk/spksrc.common.mk

DEPENDS = cross/$(SPK_NAME)

DESCRIPTION = inotify-tools is a C library and a set of command-line programs for Linux providing a simple interface to inotify. 
RELOAD_UI = no
DISPLAY_NAME = inotify-tools
STARTABLE = no

CHANGELOG = "1. Initial release"

HOMEPAGE = https://github.com/inotify-tools/inotify-tools/
LICENSE  = GPLv2

SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk

SPK_NAME = fish
SPK_VERS = 3.7.1
SPK_REV = 7
SPK_ICON = src/ascii_fish.png

DEPENDS = cross/fish

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = fish is a smart and user-friendly command line shell for Linux, macOS, and the rest of the family.
DISPLAY_NAME = fish
STARTABLE = no
CHANGELOG = "Update fish to 3.7.1"

HOMEPAGE = https://fishshell.com
LICENSE = GPL-2.0
LICENSE_FILE = $(WORK_DIR)/$(SPK_NAME)-$(SPK_VERS)/COPYING

SERVICE_SETUP = src/service-setup.sh

SPK_COMMANDS = bin/fish bin/fish_indent bin/fish_key_reader

include ../../mk/spksrc.spk.mk

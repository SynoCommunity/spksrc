SPK_NAME = fish
SPK_VERS = 3.3.1
SPK_REV = 4
SPK_ICON = src/ascii_fish.png

DEPENDS = cross/fish

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = fish is a smart and user-friendly command line shell for Linux, macOS, and the rest of the family.
RELOAD_UI = no
DISPLAY_NAME = fish
STARTABLE = no
CHANGELOG = "1. Update to 3.3.1"

HOMEPAGE = https://fishshell.com
LICENSE = Custom
LICENSE_FILE = $(WORK_DIR)/$(SPK_NAME)-$(SPK_VERS)/doc_src/license.rst

SERVICE_SETUP = src/service-setup.sh

SPK_COMMANDS = bin/fish bin/fish_indent bin/fish_key_reader

include ../../mk/spksrc.spk.mk

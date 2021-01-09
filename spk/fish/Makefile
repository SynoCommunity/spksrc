SPK_NAME = fish
SPK_VERS = 3.1.2
SPK_REV = 1
SPK_ICON = src/ascii_fish.png

DEPENDS = cross/fish

MAINTAINER = SynoCommunity
DESCRIPTION = fish is a smart and user-friendly command line shell for Linux, macOS, and the rest of the family.
RELOAD_UI = no
DISPLAY_NAME = fish
STARTABLE = no
CHANGELOG = "Initial release"

HOMEPAGE = https://fishshell.com
LICENSE = Custom

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS)

SERVICE_SETUP = src/service-setup.sh
SPK_COMMANDS = bin/fish bin/fish_indent bin/fish_key_reader

include ../../mk/spksrc.spk.mk

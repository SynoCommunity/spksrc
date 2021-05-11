SPK_NAME = kiwix
SPK_VERS = 3.1.2
SPK_REV 	= 1
SPK_ICON = src/kiwix.png

DEPENDS = cross/kiwix-tools

# libicu limits
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.kiwix.org/
DESCRIPTION = Kiwix is an offline reader for online content like Wikipedia, Project Gutenberg, or TED Talks. It makes knowledge available to people with no or limited internet access. The software as well as the content is free to use for anyone.
LICENSE  = GPLv3

MAINTAINER = hgy59
DISPLAY_NAME = Kiwix
CHANGELOG = "Initial package release"

STARTABLE = no

SPK_COMMANDS = bin/kiwix-manage bin/kiwix-read bin/kiwix-search bin/kiwix-serve

include ../../mk/spksrc.spk.mk

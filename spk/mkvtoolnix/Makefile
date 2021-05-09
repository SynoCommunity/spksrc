SPK_NAME = mkvtoolnix
SPK_VERS = 9.7.1
SPK_REV = 1
SPK_ICON = src/$(SPK_NAME).png

DEPENDS = cross/$(SPK_NAME)

# toolchain compiler too old (C++14 required)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)

MAINTAINER = cytec
DESCRIPTION = MKVToolNix is a set of tools to create, alter and inspect Matroska files.
CHANGELOG = "Initial package release"
DISPLAY_NAME = MKVToolNix
STARTABLE = no

HOMEPAGE = https://mkvtoolnix.download/index.html
LICENSE  = GPLv2

SPK_COMMANDS = bin/mkvextract bin/mkvinfo bin/mkvmerge bin/mkvpropedit

include ../../mk/spksrc.spk.mk

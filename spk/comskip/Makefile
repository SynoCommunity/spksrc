SPK_NAME = comskip
SPK_VERS = 0.83
SPK_REV = 14
SPK_ICON = src/comskip.png

FFMPEG_PACKAGE = ffmpeg7

# ffmpeg-7 no longer support 88f6281 (armv5) and ffmpeg-7.1 hi3535 (armv7l)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)

DEPENDS = cross/comskip
SPK_DEPENDS = $(FFMPEG_PACKAGE)

STARTABLE = no

MAINTAINER = SynoCommunity
DESCRIPTION = Comskip is a free mpeg commercial detector. Read the wiki on how to use and configure it.
DISPLAY_NAME = Comskip
CHANGELOG = "1. Update to FFMPEG 7.1.3"

HOMEPAGE = https://www.kaashoek.com/comskip/
LICENSE = LGPL
HELPURL = https://github.com/SynoCommunity/spksrc/wiki/Comskip

SPK_COMMANDS = bin/comskip

POST_STRIP_TARGET = comskip_extra_install

include ../../mk/spksrc.spk-ffmpeg.mk

.PHONY: comskip_extra_install

comskip_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/comskip.ini $(STAGING_DIR)/var/comskip.ini
	install -m 644 src/comskip.dictionary $(STAGING_DIR)/var/comskip.dictionary

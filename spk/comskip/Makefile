SPK_NAME = comskip
SPK_VERS = 0.83
SPK_REV = 13
SPK_ICON = src/comskip.png

FFMPEG_PACKAGE = ffmpeg7

# ffmpeg7 no longer support armv5
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

DEPENDS = cross/comskip
SPK_DEPENDS = $(FFMPEG_PACKAGE)

STARTABLE = no

MAINTAINER = SynoCommunity
DESCRIPTION = Comskip is a free mpeg commercial detector. Read the wiki on how to use and configure it.
DISPLAY_NAME = Comskip
CHANGELOG = "1. Update to version 0.83<br/>2. Migrate to using ffmpeg7"

HOMEPAGE = https://www.kaashoek.com/comskip/
LICENSE = LGPL
HELPURL = https://github.com/SynoCommunity/spksrc/wiki/Comskip

SPK_COMMANDS = bin/comskip

POST_STRIP_TARGET = comskip_extra_install

include ../../mk/spksrc.ffmpeg.mk

.PHONY: comskip_extra_install

comskip_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/comskip.ini $(STAGING_DIR)/var/comskip.ini
	install -m 644 src/comskip.dictionary $(STAGING_DIR)/var/comskip.dictionary

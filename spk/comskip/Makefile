SPK_NAME = comskip
SPK_VERS = 0.83
SPK_REV = 15
SPK_ICON = src/comskip.png

FFMPEG_PACKAGE = ffmpeg8

# Depends on ffmpeg8, which needs gcc 4.9 -- refuse any older toolchain (matches
# ffmpeg8's own MIN_GCC_VERSION and covers armv5 / armv7l / old ppc dynamically).
MIN_GCC_VERSION = 4.9

DEPENDS = cross/comskip

STARTABLE = no

MAINTAINER = SynoCommunity
DESCRIPTION = Comskip is a free mpeg commercial detector. Read the wiki on how to use and configure it.
DISPLAY_NAME = Comskip
CHANGELOG = "1. Update to FFMPEG 8.1.2"

HOMEPAGE = https://www.kaashoek.com/comskip/
LICENSE = LGPL
HELPURL = https://github.com/SynoCommunity/spksrc/wiki/Comskip

SPK_COMMANDS = bin/comskip

POST_STRIP_TARGET = comskip_extra_install

include ../../mk/spksrc.spk-meta.mk

.PHONY: comskip_extra_install

comskip_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/comskip.ini $(STAGING_DIR)/var/comskip.ini
	install -m 644 src/comskip.dictionary $(STAGING_DIR)/var/comskip.dictionary

SPK_NAME = comskip
SPK_VERS = 0.82.010
SPK_REV = 12
SPK_ICON = src/comskip.png

FFMPEG_PACKAGE = ffmpeg5
DEPENDS = cross/comskip
SPK_DEPENDS = $(FFMPEG_PACKAGE)

STARTABLE = no

MAINTAINER = SynoCommunity
DESCRIPTION = Comskip is a free mpeg commercial detector. Read the wiki on how to use and configure it.
DISPLAY_NAME = Comskip
CHANGELOG = "1. Update to latest git hash from June 7th 2024<br/>2. Migrate to using ffmpeg5 version 5.1.5 using new synocli-videodriver package"

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

SPK_NAME = comskip
SPK_VERS = 0.82.010
SPK_REV = 5
SPK_ICON = src/comskip.png

DEPENDS = cross/$(SPK_NAME)

STARTABLE = no

MAINTAINER = schumi2004
DESCRIPTION = Comskip is a free mpeg commercial detector. Read the wiki on how to use and configure it.
DISPLAY_NAME = Comskip
CHANGELOG = "1. Update to ffmpeg 4.3.1"

HOMEPAGE = https://www.kaashoek.com/comskip/
LICENSE = LGPL
HELPURL = https://github.com/SynoCommunity/spksrc/wiki/Comskip

SPK_COMMANDS = bin/comskip

POST_STRIP_TARGET = comskip_extra_install

# Reuse FFmpeg libraries
export FFMPEG_DIR = $(shell pwd)/../ffmpeg/work-$(ARCH)-$(TCVERSION)/install/var/packages/ffmpeg/target

ifneq ($(wildcard $(FFMPEG_DIR)),)
PRE_DEPEND_TARGET = comskip_pre_depend
SPK_DEPENDS = "ffmpeg>4.2"
endif

include ../../mk/spksrc.spk.mk

.PHONY: comskip_pre_depend comskip_extra_install

FFMPEG_LIBS = libswresample.pc libavutil.pc libavformat.pc libavcodec.pc
comskip_pre_depend:
	mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	$(foreach lib,$(FFMPEG_LIBS),ln -sf $(FFMPEG_DIR)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)

comskip_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/comskip.ini $(STAGING_DIR)/var/comskip.ini
	install -m 644 src/comskip.dictionary $(STAGING_DIR)/var/comskip.dictionary

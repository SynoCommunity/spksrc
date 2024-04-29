SPK_NAME = comskip
SPK_VERS = 0.82.010
SPK_REV = 10
SPK_ICON = src/comskip.png

DEPENDS = cross/$(SPK_NAME)

STARTABLE = no

MAINTAINER = SynoCommunity
DESCRIPTION = Comskip is a free mpeg commercial detector. Read the wiki on how to use and configure it.
DISPLAY_NAME = Comskip
CHANGELOG = "1. Update to latest git hash from April 7th 2022<br/>2. Migrate to using ffmpeg4 version 4.4.3"

HOMEPAGE = https://www.kaashoek.com/comskip/
LICENSE = LGPL
HELPURL = https://github.com/SynoCommunity/spksrc/wiki/Comskip

SPK_COMMANDS = bin/comskip

POST_STRIP_TARGET = comskip_extra_install

# Reuse FFmpeg libraries
export FFMPEG_VERSION = 4
export FFMPEG_DIR = $(realpath $(shell pwd)/../ffmpeg$(FFMPEG_VERSION)/work-$(ARCH)-$(TCVERSION)/install/var/packages/ffmpeg$(subst 4,,$(FFMPEG_VERSION))/target)

ifneq ($(wildcard $(FFMPEG_DIR)),)
export ADDITIONAL_LDFLAGS = -Wl,--rpath-link,$(FFMPEG_DIR)/lib -Wl,--rpath,/var/packages/ffmpeg/target$(subst 4,,$(FFMPEG_VERSION))/lib
PRE_DEPEND_TARGET = comskip_pre_depend
SPK_DEPENDS := "ffmpeg$(subst 4,,$(FFMPEG_VERSION))>$(shell sed -n 's/^SPK_VERS = \(.*\)/\1/p' $(shell pwd)/../ffmpeg$(FFMPEG_VERSION)/Makefile | cut -c -3)"
endif

include ../../mk/spksrc.spk.mk

.PHONY: comskip_pre_depend comskip_extra_install

FFMPEG_LIBS  = libswresample.pc
FFMPEG_LIBS += libavutil.pc
FFMPEG_LIBS += libavformat.pc
FFMPEG_LIBS += libavcodec.pc
FFMPEG_LIBS += libswscale.pc

comskip_pre_depend:
	mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	$(foreach lib,$(FFMPEG_LIBS),ln -sf $(FFMPEG_DIR)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)

comskip_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/comskip.ini $(STAGING_DIR)/var/comskip.ini
	install -m 644 src/comskip.dictionary $(STAGING_DIR)/var/comskip.dictionary

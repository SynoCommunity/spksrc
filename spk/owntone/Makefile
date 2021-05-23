SPK_NAME = owntone
SPK_VERS = 27.4
SPK_REV = 1
SPK_ICON = src/owntone.png

DEPENDS = cross/owntone

MAINTAINER = SynoCommunity
DESCRIPTION = OwnTone is forked-daapd's new name! Linux/FreeBSD DAAP (iTunes) and MPD media server with support for AirPlay devices (multiroom), Apple Remote (and compatibles), Chromecast, Spotify and internet radio.

DISPLAY_NAME = OwnTone

HOMEPAGE = http://owntone.github.io/owntone-server
LICENSE  = GPLv2

STARTABLE = yes
SERIVCE_PORT = 3689
ADMIN_PORT = $(SERIVCE_PORT)

# Reuse FFmpeg libraries
export FFMPEG_DIR = $(shell pwd)/../ffmpeg/work-$(ARCH)-$(TCVERSION)/install/var/packages/ffmpeg/target

ifneq ($(wildcard $(FFMPEG_DIR)),)
PRE_DEPEND_TARGET = owntone_pre_depend
SPK_DEPENDS = "ffmpeg>4.2"
# Use FFMPEG package shared libraries
FFMPEG_LIBS = libavcodec.pc libavdevice.pc libavfilter.pc libavformat.pc libavresample.pc libavutil.pc
endif

include ../../mk/spksrc.spk.mk

.PHONY: owntone_pre_depend
owntone_pre_depend:
	mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	$(foreach lib,$(FFMPEG_LIBS),ln -sf $(FFMPEG_DIR)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)

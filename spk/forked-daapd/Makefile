SPK_NAME = forked-daapd
SPK_VERS = 27.2
SPK_REV = 1
SPK_ICON = src/forked-daapd.png

DEPENDS = cross/forked-daapd

MAINTAINER = SynoCommunity
DESCRIPTION = Linux/FreeBSD DAAP (iTunes) and MPD media server with support for AirPlay devices (multiroom), Apple Remote (and compatibles), Chromecast, Spotify and internet radio.

RELOAD_UI = yes
DISPLAY_NAME = Forked DAAPd

HOMEPAGE = http://ejurgensen.github.io/forked-daapd/
LICENSE  = GPLv2

STARTABLE=yes

include ../../mk/spksrc.common.mk

# Reuse FFmpeg libraries
export FFMPEG_DIR = $(shell pwd)/../ffmpeg/work-$(ARCH)-$(TCVERSION)/install/var/packages/ffmpeg/target

ifneq ($(wildcard $(FFMPEG_DIR)),)
PRE_DEPEND_TARGET = daapd_pre_depend
SPK_DEPENDS = "ffmpeg>4.2"
# Use FFMPEG package shared libraries
FFMPEG_LIBS = libavcodec.pc libavdevice.pc libavfilter.pc libavformat.pc libavresample.pc libavutil.pc
endif

include ../../mk/spksrc.spk.mk

.PHONY: daapd_pre_depend
daapd_pre_depend:
	mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	$(foreach lib,$(FFMPEG_LIBS),ln -sf $(FFMPEG_DIR)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)

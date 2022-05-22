SPK_NAME = owntone
SPK_VERS = 28.1
SPK_REV = 1
SPK_ICON = src/owntone.png

DEPENDS = cross/owntone

MAINTAINER = SynoCommunity
DESCRIPTION = OwnTone is forked-daapd\'s new name. Linux/FreeBSD DAAP \(iTunes\) and MPD media server with support for AirPlay devices \(multiroom\), Apple Remote \(and compatibles\), Chromecast, Spotify and internet radio.
CHANGELOG = "Initial package release."

DISPLAY_NAME = OwnTone

HOMEPAGE = http://owntone.github.io/owntone-server
LICENSE  = GPLv2

# owntone's ports
# 3689	(daap)
# 3688	(web UI)
# 6600	(MPD client requests)

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes
SERVICE_PORT = 3689
ADMIN_PORT = $(SERIVCE_PORT)

# Reuse FFmpeg libraries
export FFMPEG_DIR = $(shell pwd)/../ffmpeg/work-$(ARCH)-$(TCVERSION)/install/var/packages/ffmpeg/target

ifneq ($(wildcard $(FFMPEG_DIR)),)
PRE_DEPEND_TARGET = owntone_pre_depend
SPK_DEPENDS = "ffmpeg>4.2"
# Use some shared libraries of the FFMPEG package
FFMPEG_LIBS = libavformat.pc libavcodec.pc libavutil.pc libavfilter.pc
FFMPEG_LIBS += libswscale.pc libpostproc.pc
FFMPEG_LIBS += libswresample.pc libavresample.pc
endif

POST_STRIP_TARGET = owntone_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: owntone_pre_depend
owntone_pre_depend:
	mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	$(foreach lib,$(FFMPEG_LIBS),ln -sf $(FFMPEG_DIR)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)

.PHONY: owntone_extra_install
owntone_extra_install:
	install -d -m 755 $(STAGING_DIR)/var
	install -m 644 src/owntone.conf $(STAGING_DIR)/var

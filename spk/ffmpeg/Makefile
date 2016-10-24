SPK_NAME = ffmpeg
SPK_VERS = 3.1.2
SPK_REV = 3
SPK_ICON = src/ffmpeg.png
DSM_UI_DIR = app
CHANGELOG = "1. Update ffmpeg to 3.1<br>2. Support nasm 2.12.02 and yasm 1.3 added. Added 12 new libs/codecs and update all depends : fdk-acc 0.1.4, fontconfig 2.12.1, freetype 2.6.5, fribidi 0.19.7, lame 3.99.5, libass 0.13.2, libbluray 0.9.3, libnuma 2.0.11, libvorbis 1.3.5, libvpx 1.6.0, opencore-amr 0.1.3, openjpeg 2.1.0, opus 1.1.3, rtmdpdump 550a0ca, soxr 0.1.2, vo-amrwbenc 0.1.3, x264 20160816-2245-stable, x265 2.0"

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = cytec
DESCRIPTION = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library.
RELOAD_UI = yes
DISPLAY_NAME = ffmpeg
STARTABLE = no

HOMEPAGE = http://www.ffmpeg.org/
LICENSE  = LGPL 2.1

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = ffmpeg_extra_install


include ../../mk/spksrc.spk.mk

.PHONY: ffmpeg_extra_install
znc_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

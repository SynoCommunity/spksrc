SPK_NAME = ffmpeg
SPK_VERS = 2.1.1
SPK_REV = 1
SPK_ICON = src/ffmpeg.png
DSM_UI_DIR = app
CHANGELOG = update ffmpeg

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = cytec
DESCRIPTION = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library.
RELOAD_UI = yes
DISPLAY_NAME = ffmpeg

HOMEPAGE = http://www.ffmpeg.org/
LICENSE  =

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

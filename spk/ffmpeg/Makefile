SPK_NAME = ffmpeg
SPK_VERS = 3.0
SPK_REV = 2
SPK_ICON = src/ffmpeg.png
DSM_UI_DIR = app
CHANGELOG = "1. Update ffmpeg to 3.0<br>2. Added 13 new libs/codecs<br>3. Support for yasm added"


DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library.
RELOAD_UI = yes
DISPLAY_NAME = ffmpeg
STARTABLE = no

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

SPK_NAME = ffmpeg
SPK_VERS = 3.2.2
SPK_REV = 5
SPK_ICON = src/ffmpeg.png
CHANGELOG = "1. Update ffmpeg to 3.2.2"

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = cytec
DESCRIPTION = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library.
DISPLAY_NAME = ffmpeg
STARTABLE = no

HOMEPAGE = http://www.ffmpeg.org/
LICENSE  = LGPL 2.1

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

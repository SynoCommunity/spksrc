SPK_NAME = ffmpeg
SPK_VERS = 3.2.2
SPK_REV = 5
SPK_ICON = src/ffmpeg.png
CHANGELOG = "1. Update ffmpeg to 3.2.2<br>2. Update all depends : libavcodec 57.64.101, libavdevice 57.1.100, libavfilter 6.65.100, libavformat 57.56.100, libavutil 55.34.100, libpostproc 54.1.100, libswresample 2.3.100, libswscale 4.2.100"

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

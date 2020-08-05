SPK_NAME = ffmpeg
SPK_VERS = 4.2.4
SPK_REV = 33
SPK_ICON = src/ffmpeg.png
CHANGELOG = "1. Update ffmpeg to 4.2.4<br/>2. Update Intel libva to v2.7 and Intel driver toolstack to 20Q1 v20.1.1<br/>3. Update all trivial dependencies (x264, x265, libaom, libogg, freetype, fribidi, libbluray)br/>4. Update libaom to version 2.0.0-rc1<br/>5. Add experimental support for SVT-AV1 and SVT-HEVC<br/>6. Simplify access to vainfo binary (intel platforms only)<br/>6. Enable libtheora support"

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = th0ma7
DESCRIPTION = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library.
DESCRIPTION_FRE = FFmpeg est une solution complète multiplateforme pour enregistrer, convertir et diffuser du contenu audio et vidéo. Il comprend libavcodec - la principale bibliothèque de codecs audio/vidéo.
DISPLAY_NAME = ffmpeg
STARTABLE = no

HOMEPAGE = http://www.ffmpeg.org/
LICENSE  = GPLv3

SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk

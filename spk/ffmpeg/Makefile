SPK_NAME = ffmpeg
SPK_VERS = 4.2.1
SPK_REV = 22
SPK_ICON = src/ffmpeg.png
CHANGELOG = "1. Update ffmpeg to 4.2.1<br/>2. Add AOMedia Video 1 (AV1) for ARMv7, ARMv8 and x86 platforms<br/>3. apparmor permission denied fix<br/>4. Port Synology FFMPEG 3.3.7 changes and fixes for VideoStation and MediaServer<br/>5. Enable Synology -hls_seek_time option<br/>6. Enable Fraunhofer FDK AAC<br/>7. Fix persmission for VAAPI access<br/>7. Compiler workaround for DTS-HD MA stream decoding<br/>8. Update VAAPI toolstack<br/>9. Add x264profile option<br/>10. Add Intel Quick Sync support"

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

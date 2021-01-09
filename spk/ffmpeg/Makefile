SPK_NAME = ffmpeg
SPK_VERS = 4.3.1
SPK_REV = 35
SPK_ICON = src/ffmpeg.png
CHANGELOG = "1. Update ffmpeg to 4.3.1<br/>2. Update Intel libva to version 2.8 and media drivers 2020Q2<br/>3. Enable ZeroMQ support<br/>4. Update svt-hevc to 1.5.0<br/>5. Update x264 to July 2nd git hash and use github mirror<br/>6. Update libaom to version 2.0.0<br/>7. Update SVT-AV1 to version 0.8.4<br/>8. Update x265 to version 3.4<br/>9. Enable libzmq support with version 4.3.2<br/>10. Fix a build issue with libshine"

CONF_DIR = src/conf

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = th0ma7
DESCRIPTION = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library.  More information from SynoCommunity FFmpeg package available at https://github.com/SynoCommunity/spksrc/wiki/FAQ-FFmpeg
DESCRIPTION_FRE = FFmpeg est une solution complète multiplateforme pour enregistrer, convertir et diffuser du contenu audio et vidéo. Il comprend libavcodec - la principale bibliothèque de codecs audio/vidéo.  Informations additionnelles concernant le paquet FFmpeg de SynoCommunity disponibles à https://github.com/SynoCommunity/spksrc/wiki/FAQ-FFmpeg
DISPLAY_NAME = ffmpeg
STARTABLE = no

HOMEPAGE = https://www.ffmpeg.org/
LICENSE  = GPLv3

SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk

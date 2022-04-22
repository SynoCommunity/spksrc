SPK_NAME = ffmpeg
SPK_VERS = 4.4.1
SPK_REV = 42
SPK_ICON = src/ffmpeg.png
CHANGELOG = "1. Update to version 4.4.1<br/>2. Update intel-media-driver to 22Q1<br/>3. Import Jellyfin project patches<br/>4. Multiple dependency updates: fribidi, libaom, libass, libbluray, SVT-AV1, x264<br/>5. Enable dav1d decoder<br/>6. Enable libopenjpeg en/decoder<br/>7. Enable RIST protocol<br/>8. Fix an issue causing tvheadend to segfault on DSM7 x86_64"

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

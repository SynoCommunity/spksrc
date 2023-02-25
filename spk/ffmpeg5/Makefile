SPK_NAME = ffmpeg5
SPK_VERS = 5.1.2
SPK_REV = 1
SPK_ICON = src/ffmpeg.png
CHANGELOG = "1. Initial package release"

CONF_DIR = src/conf

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = th0ma7
DESCRIPTION = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library.  More information from SynoCommunity FFmpeg package available at https://github.com/SynoCommunity/spksrc/wiki/FAQ-FFmpeg
DESCRIPTION_FRE = FFmpeg est une solution complète multiplateforme pour enregistrer, convertir et diffuser du contenu audio et vidéo. Il comprend libavcodec - la principale bibliothèque de codecs audio/vidéo.  Informations additionnelles concernant le paquet FFmpeg de SynoCommunity disponibles à https://github.com/SynoCommunity/spksrc/wiki/FAQ-FFmpeg
DISPLAY_NAME = ffmpeg5
STARTABLE = no

HOMEPAGE = https://www.ffmpeg.org/
LICENSE  = GPLv3

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
SERVICE_SETUP = src/service-setup.sh
endif

include ../../mk/spksrc.spk.mk

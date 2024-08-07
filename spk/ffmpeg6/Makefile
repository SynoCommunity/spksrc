SPK_NAME = ffmpeg6
SPK_VERS = 6.0.1
SPK_REV = 4
SPK_ICON = src/ffmpeg.png
CHANGELOG = "1. Update to version 6.0.1<br/>2. Update Jellyfin upstream patches<br/>3. Update Intel Media Driver 2024Q1 Release (DSM7 only)<br/>4. Migrate DSM7 from MFX to Intel Video Processing Library (Intel-VPL)<br/>5. Update to latest version of x264 (fix for \#6176) - rev4 UNRELEASED"

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = th0ma7
DESCRIPTION = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library.  More information from SynoCommunity FFmpeg package available at https://github.com/SynoCommunity/spksrc/wiki/FAQ-FFmpeg
DESCRIPTION_FRE = FFmpeg est une solution complète multiplateforme pour enregistrer, convertir et diffuser du contenu audio et vidéo. Il comprend libavcodec - la principale bibliothèque de codecs audio/vidéo.  Informations additionnelles concernant le paquet FFmpeg de SynoCommunity disponibles à https://github.com/SynoCommunity/spksrc/wiki/FAQ-FFmpeg
DISPLAY_NAME = FFmpeg $(firstword $(subst ., ,$(SPK_VERS)))
STARTABLE = no

HOMEPAGE = https://www.ffmpeg.org/
LICENSE  = GPLv3

POST_STRIP_TARGET = $(SPK_NAME)_extra_install

SPK_COMMANDS  = bin/ffprobe
SPK_COMMANDS += bin/$(SPK_NAME)

include ../../mk/spksrc.archs.mk

ifeq ($(call version_ge, $(TCVERSION), 7.0),1)
SERVICE_USER = auto
VIDEODRIVER = on
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
SERVICE_SETUP = src/service-setup.sh
SPK_COMMANDS += bin/vainfo
endif

include ../../mk/spksrc.spk.mk

.PHONY: $(SPK_NAME)_extra_install
$(SPK_NAME)_extra_install:
	cd $(STAGING_DIR)/bin && ln -sf ffmpeg $(SPK_NAME)

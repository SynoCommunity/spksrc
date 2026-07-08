SPK_NAME = ffmpeg8
SPK_VERS = 8.1.2
SKG_MINOR_VERS = $(firstword $(subst ., ,$(SPK_VERS)))
SPK_REV = 2
SPK_ICON = src/ffmpeg.png
CHANGELOG = "1. Update to version 8.1.2"

DEPENDS = cross/ffmpeg8
VIDEODRV_PACKAGE = synocli-videodriver

# requires c11 and proper atomic using gcc-4.9+ support
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)

MAINTAINER = th0ma7
DESCRIPTION = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library.  More information from SynoCommunity FFmpeg package available at https://github.com/SynoCommunity/spksrc/wiki/FAQ-FFmpeg
DESCRIPTION_FRE = FFmpeg est une solution complète multiplateforme pour enregistrer, convertir et diffuser du contenu audio et vidéo. Il comprend libavcodec - la principale bibliothèque de codecs audio/vidéo.  Informations additionnelles concernant le paquet FFmpeg de SynoCommunity disponibles à https://github.com/SynoCommunity/spksrc/wiki/FAQ-FFmpeg
DISPLAY_NAME = FFmpeg $(firstword $(subst ., ,$(SPK_VERS)))
STARTABLE = no

HOMEPAGE = https://www.ffmpeg.org/
LICENSE  = GPLv3

POST_STRIP_TARGET = $(SPK_NAME)_extra_install

SPK_COMMANDS  = bin/ffprobe$(SKG_MINOR_VERS)
SPK_COMMANDS += bin/ffmpeg$(SKG_MINOR_VERS)

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge, $(TCVERSION), 7.0),1)
SERVICE_USER = auto
VIDEODRIVER = on
endif

# GPU diagnostic tools alongside the driver libraries
# (package only exists for x64 on DSM 7.1+)
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
ifeq ($(call version_ge, $(TCVERSION), 7.1),1)
SPK_DEPENDS = "synocli-videodriver-tools"
endif
endif

include ../../mk/spksrc.spk-meta.mk

.PHONY: $(SPK_NAME)_extra_install
$(SPK_NAME)_extra_install:
	cd $(STAGING_DIR)/bin && ln -sf ffprobe ffprobe$(SKG_MINOR_VERS)
	cd $(STAGING_DIR)/bin && ln -sf ffmpeg ffmpeg$(SKG_MINOR_VERS)

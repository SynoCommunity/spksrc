SPK_NAME = ffmpeg6
SPK_VERS = 6.1.6
SKG_MINOR_VERS = $(firstword $(subst ., ,$(SPK_VERS)))
SPK_REV = 7
SPK_ICON = src/ffmpeg.png
CHANGELOG = "1. Update ffmpeg to 6.1.6 with the jellyfin v6.0.1-8 patchset ported to 6.1<br/>2. Re-enable libjxl (JPEG-XL)<br/>3. Now using new synocli-videodriver package<br/>4. Align package with ffmpeg7/ffmpeg8"

DEPENDS = cross/ffmpeg6
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

include ../../mk/spksrc.spk-meta.mk

.PHONY: $(SPK_NAME)_extra_install
$(SPK_NAME)_extra_install:
	cd $(STAGING_DIR)/bin && ln -sf ffprobe ffprobe$(SKG_MINOR_VERS)
	cd $(STAGING_DIR)/bin && ln -sf ffmpeg ffmpeg$(SKG_MINOR_VERS)

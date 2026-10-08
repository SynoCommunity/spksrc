SPK_NAME = ffmpeg
SPK_VERS = 4.4.8
SKG_MINOR_VERS = $(firstword $(subst ., ,$(SPK_VERS)))
SPK_REV = 52
SPK_ICON = src/ffmpeg.png
CHANGELOG  = "1. Update to version 4.4.8<br/>"
CHANGELOG += "2. Update to jellyfin-ffmpeg v4.4.1-4 patchset<br/>"
CHANGELOG += "3. Now using new synocli-videodriver package<br/>"
CHANGELOG += "4. Align package with ffmpeg7/ffmpeg8<br/>"
CHANGELOG += "5. Enable DSM 5.2 support (x86, PowerPC ppc853x and ARMv5 88f6281)<br/>"
CHANGELOG += "6. PowerPC ppc853x now built as e500v2 instead of e500<br/>"
CHANGELOG += "7. Internal build options now follow toolchain capabilities"

DEPENDS = cross/ffmpeg4
VIDEODRV_PACKAGE = synocli-videodriver

MAINTAINER = th0ma7
DESCRIPTION = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library.  More information from SynoCommunity FFmpeg package available at https://docs.synocommunity.com/packages/ffmpeg/
DESCRIPTION_FRE = FFmpeg est une solution complète multiplateforme pour enregistrer, convertir et diffuser du contenu audio et vidéo. Il comprend libavcodec - la principale bibliothèque de codecs audio/vidéo.  Informations additionnelles concernant le paquet FFmpeg de SynoCommunity disponibles à https://docs.synocommunity.com/packages/ffmpeg/
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

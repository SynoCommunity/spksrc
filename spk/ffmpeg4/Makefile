SPK_NAME = ffmpeg
SPK_VERS = 4.4.3
SPK_REV = 48
SPK_ICON = src/ffmpeg.png
CHANGELOG = "1. Change package directory to ffmpeg4<br/>2. Enable openh264<br/>3. Enable twolane<br/>4. Enable aarch64 asm neon optimization<br/>5. Update dav1d to version 1.1.0<br/>6. Update frei0r to version 2.2.0<br/>7. Update libvpx to version 1.13<br/>8. Update x264 to latest git commit<br/>9. Update SVT-AV1 to version 1.4.1<br/>10. Update libass to version 0.17.1"

CONF_DIR = src/conf

DEPENDS = cross/ffmpeg4

# Enforce using ffmpeg4 directory
INSTALL_PREFIX = /var/packages/ffmpeg4/target

MAINTAINER = th0ma7
DESCRIPTION = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library.  More information from SynoCommunity FFmpeg package available at https://github.com/SynoCommunity/spksrc/wiki/FAQ-FFmpeg
DESCRIPTION_FRE = FFmpeg est une solution complète multiplateforme pour enregistrer, convertir et diffuser du contenu audio et vidéo. Il comprend libavcodec - la principale bibliothèque de codecs audio/vidéo.  Informations additionnelles concernant le paquet FFmpeg de SynoCommunity disponibles à https://github.com/SynoCommunity/spksrc/wiki/FAQ-FFmpeg
DISPLAY_NAME = ffmpeg $(SPK_VERS)
STARTABLE = no

HOMEPAGE = https://www.ffmpeg.org/
LICENSE  = GPLv3

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
SERVICE_SETUP = src/service-setup.sh
endif

POST_STRIP_TARGET = ffmpeg4_extra_install

SPK_USR_LOCAL_LINKS  = bin:bin/ffmpeg
SPK_USR_LOCAL_LINKS += bin:bin/ffmpeg4

include ../../mk/spksrc.spk.mk

.PHONY: ffmpeg4_extra_install
ffmpeg4_extra_install:
	cd $(STAGING_DIR)/bin && ln -sf ffmpeg ffmpeg4

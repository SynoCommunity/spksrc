SPK_NAME = chromaprint
SPK_VERS = 1.6.0
SPK_REV = 25
SPK_ICON = src/chromaprint.png

FFMPEG_PACKAGE = ffmpeg7
DEPENDS = cross/chromaprint
SPK_DEPENDS = $(FFMPEG_PACKAGE)

# ffmpeg-7 no longer support 88f6281 (armv5) and ffmpeg-7.1 hi3535 (armv7l)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)

STARTABLE = no

MAINTAINER = SynoCommunity
DESCRIPTION = Chromaprint is the core component of the AcoustID project. It\'s a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
DISPLAY_NAME = Chromaprint
CHANGELOG = "1. Update to FFMPEG 7.1.3"

HOMEPAGE   = https://acoustid.org/chromaprint
LICENSE    = LGPL2.1+

SPK_COMMANDS = bin/fpcalc

include ../../mk/spksrc.spk-ffmpeg.mk

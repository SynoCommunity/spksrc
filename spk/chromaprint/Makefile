SPK_NAME = chromaprint
SPK_VERS = 1.6.0
SPK_REV = 26
SPK_ICON = src/chromaprint.png

FFMPEG_PACKAGE = ffmpeg8
DEPENDS = cross/chromaprint

# ffmpeg-8 no longer support 88f6281 (armv5) and hi3535 (armv7l)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)

STARTABLE = no

MAINTAINER = SynoCommunity
DESCRIPTION = Chromaprint is the core component of the AcoustID project. It\'s a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
DISPLAY_NAME = Chromaprint
CHANGELOG = "1. Update to FFMPEG 8.1.2"

HOMEPAGE   = https://acoustid.org/chromaprint
LICENSE    = LGPL2.1+

SPK_COMMANDS = bin/fpcalc

include ../../mk/spksrc.spk-meta.mk

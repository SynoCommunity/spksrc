SPK_NAME = chromaprint
SPK_VERS = 1.5.2
SPK_REV = 22
SPK_ICON = src/chromaprint.png

FFMPEG_PACKAGE = ffmpeg7
DEPENDS = cross/chromaprint
SPK_DEPENDS = $(FFMPEG_PACKAGE)

# ffmpeg7 requires c11 support
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

STARTABLE = no

MAINTAINER = ymartin59
DESCRIPTION = Chromaprint is the core component of the AcoustID project. It\'s a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
DISPLAY_NAME = Chromaprint
CHANGELOG = "1. Version 1.5.1 + Arch Linux compatibility patches<br/>2. Update to FFMPEG 7.0.2"

HOMEPAGE   = https://acoustid.org/chromaprint
LICENSE    = LGPL2.1+

SPK_COMMANDS = bin/fpcalc

include ../../mk/spksrc.ffmpeg.mk

SPK_NAME = chromaprint
SPK_VERS = 1.5.2
SPK_REV = 21
SPK_ICON = src/chromaprint.png

FFMPEG_PACKAGE = ffmpeg6
DEPENDS = cross/$(SPK_NAME)
SPK_DEPENDS = $(FFMPEG_PACKAGE)

STARTABLE = no

MAINTAINER = ymartin59
DESCRIPTION = Chromaprint is the core component of the AcoustID project. It\'s a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
DISPLAY_NAME = Chromaprint
CHANGELOG = "1. Version 1.5.1 + Arch Linux compatibility patches<br/>2. 2. Update to FFMPEG 6.0.1 using new synocli-videodriver package"

HOMEPAGE   = https://acoustid.org/chromaprint
LICENSE    = LGPL2.1+

SPK_COMMANDS = bin/fpcalc

include ../../mk/spksrc.ffmpeg.mk

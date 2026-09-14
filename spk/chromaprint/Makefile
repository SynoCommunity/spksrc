SPK_NAME = chromaprint
SPK_VERS = 1.6.2
SPK_REV = 27
SPK_ICON = src/chromaprint.png

FFMPEG_PACKAGE = ffmpeg8
DEPENDS = cross/chromaprint

# The ffmpeg8 chain builds through the gcc 8.5 overlay end to end -- one compiler, one
# libstdc++ ABI. Set before spksrc.common.mk, so overlay.mk's own `?=` stands down;
# `?=` here in turn stands down for a command line or an environment saying otherwise.
OVERLAY_GCC ?= 1

STARTABLE = no

MAINTAINER = SynoCommunity
DESCRIPTION = Chromaprint is the core component of the AcoustID project. It\'s a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
DISPLAY_NAME = Chromaprint
CHANGELOG  = "1. Update to version 1.6.2<br/>"
CHANGELOG += "2. Update to FFMPEG 8.1.3"

HOMEPAGE   = https://acoustid.org/chromaprint
LICENSE    = LGPL2.1+

SPK_COMMANDS = bin/fpcalc

include ../../mk/spksrc.spk-meta.mk

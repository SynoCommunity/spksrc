SPK_NAME = chromaprint
SPK_VERS = 1.6.0
SPK_REV = 26
SPK_ICON = src/chromaprint.png

FFMPEG_PACKAGE = ffmpeg8
DEPENDS = cross/chromaprint

# ffmpeg8 needs C11 -- gcc 4.9 or newer
MIN_GCC_VERSION = 4.9

# ffmpeg8 is built through the gcc 8.5 overlay wherever the vendor compiler falls short,
# so follow it: same condition, same compiler, one ABI across the chain. Linking an
# overlay-built ffmpeg8 with the vendor gcc fails on std::__cxx11 and CXXABI symbols its
# libstdc++ never had. Recursive (=): TC_GCC does not exist until the include below, and
# overlay.mk's `?=` must still see this assignment.
OVERLAY_GCC = $(if $(call version_lt,$(TC_GCC),$(MIN_GCC_VERSION)),1)

STARTABLE = no

MAINTAINER = SynoCommunity
DESCRIPTION = Chromaprint is the core component of the AcoustID project. It\'s a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
DISPLAY_NAME = Chromaprint
CHANGELOG = "1. Update to FFMPEG 8.1.2"

HOMEPAGE   = https://acoustid.org/chromaprint
LICENSE    = LGPL2.1+

SPK_COMMANDS = bin/fpcalc

include ../../mk/spksrc.spk-meta.mk

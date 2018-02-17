SPK_NAME = chromaprint
SPK_VERS = 1.4.3
SPK_REV = 6
SPK_ICON = src/chromaprint.png

DEPENDS = cross/$(SPK_NAME)

STARTABLE = no

MAINTAINER = cytec
DESCRIPTION = "Chromaprint is the core component of the AcoustID project. It's a client-side library that implements a custom algorithm for extracting fingerprints from any audio source. "
DISPLAY_NAME = Chromaprint
CHANGELOG = "Update to 1.4.3"

HOMEPAGE   = http://acoustid.org/chromaprint
LICENSE    = LGPL2.1+

include ../../mk/spksrc.common.mk

# Reuse ffmpeg libraries
# Requires to invoke: make [package|publish] ARCH= TCVERSION=
export FFMPEG_DIR = $(shell pwd)/../ffmpeg/work-$(ARCH)-$(TCVERSION)/install/var/packages/ffmpeg/target

ifneq ($(wildcard $(FFMPEG_DIR)),)
$(info Depend on ffmpeg package libraries)
SPK_DEPENDS = "ffmpeg>3.4"
else
$(warning Build spk/ffmpeg first to depend on its libraries $(FFMPEG_DIR))
endif

include ../../mk/spksrc.spk.mk

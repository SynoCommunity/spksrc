SPK_NAME = chromaprint
SPK_VERS = 1.4.3
SPK_REV = 7
SPK_ICON = src/chromaprint.png

DEPENDS = cross/$(SPK_NAME)

STARTABLE = no

MAINTAINER = ymartin59
DESCRIPTION = Chromaprint is the core component of the AcoustID project. It\'s a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
DISPLAY_NAME = Chromaprint
CHANGELOG = "Update to 1.4.3"

HOMEPAGE   = http://acoustid.org/chromaprint
LICENSE    = LGPL2.1+

include ../../mk/spksrc.common.mk

# Reuse FFmpeg libraries
export FFMPEG_DIR = $(shell pwd)/../ffmpeg/work-$(ARCH)-$(TCVERSION)/install/var/packages/ffmpeg/target

ifneq ($(wildcard $(FFMPEG_DIR)),)
PRE_DEPEND_TARGET = chromaprint_pre_depend
SPK_DEPENDS = "ffmpeg>4.1"
endif

include ../../mk/spksrc.spk.mk

.PHONY: chromaprint_pre_depend

# From library detection at cmake/modules/FindFFmpeg.cmake
FFMPEG_LIBS = libavutil.pc libavformat.pc libavcodec.pc
chromaprint_pre_depend:
	mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	$(foreach lib,$(FFMPEG_LIBS),ln -sf $(FFMPEG_DIR)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)

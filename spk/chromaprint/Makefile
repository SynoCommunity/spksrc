SPK_NAME = chromaprint
SPK_VERS = 1.5.1
SPK_REV = 19
SPK_ICON = src/chromaprint.png

DEPENDS = cross/$(SPK_NAME)

STARTABLE = no

MAINTAINER = ymartin59
DESCRIPTION = Chromaprint is the core component of the AcoustID project. It\'s a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
DISPLAY_NAME = Chromaprint
CHANGELOG = "1. Update to version 1.5.1<br/>2. Update to using ffmpeg4 version 4.4.3"

HOMEPAGE   = https://acoustid.org/chromaprint
LICENSE    = LGPL2.1+

# Reuse FFmpeg libraries
export FFMPEG4_DIR = $(shell pwd)/../ffmpeg/work-$(ARCH)-$(TCVERSION)/install/var/packages/ffmpeg4/target

ifneq ($(wildcard $(FFMPEG4_DIR)),)
export ADDITIONAL_LDFLAGS = -Wl,--rpath-link,$(FFMPEG4_DIR)/lib -Wl,--rpath,/var/packages/ffmpeg4/target/lib
PRE_DEPEND_TARGET = chromaprint_pre_depend
SPK_DEPENDS = "ffmpeg4>4.4"
endif

SPK_COMMANDS = bin/fpcalc

include ../../mk/spksrc.spk.mk

.PHONY: chromaprint_pre_depend

# From library detection at cmake/modules/FindFFmpeg.cmake
FFMPEG4_LIBS  = libavcodec.pc
FFMPEG4_LIBS += libavformat.pc
FFMPEG4_LIBS += libavutil.pc

chromaprint_pre_depend:
	mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	$(foreach lib,$(FFMPEG4_LIBS),ln -sf $(FFMPEG4_DIR)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)

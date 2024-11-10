PKG_NAME = ffmpeg
PKG_VERS = 7.0.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.ffmpeg.org/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.ffmpeg.org/
COMMENT  = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library
LICENSE  = GPLv2

# requires c11 support
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

CONFIGURE_ARGS  = --target-os=linux --cross-prefix=$(TC_PATH)$(TC_PREFIX) --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --extra-cflags="-I$(WORK_DIR)/install$(INSTALL_PREFIX)/include"
CONFIGURE_ARGS += --extra-ldflags="-L$(WORK_DIR)/install$(INSTALL_PREFIX)/lib"
CONFIGURE_ARGS += --extra-libs="-lxml2 -ldl -lm" --pkg-config=/usr/bin/pkg-config --ranlib=$(RANLIB)
CONFIGURE_ARGS += --enable-cross-compile --enable-rpath --enable-pic
CONFIGURE_ARGS += --enable-shared
CONFIGURE_ARGS += --enable-gpl --enable-version3
CONFIGURE_ARGS += --disable-debug
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --disable-doc

# Must match $(SPK_REV) from spk/ffmpeg6/Makefile
CONFIGURE_ARGS += --extra-version=$(shell sed -n 's/^SPK_REV = \(.*\)/\1/p' $(WORK_DIR)/../../../spk/ffmpeg6/Makefile)

# Enable Synology specific -hls_seek_time option and other optimizations
CONFIGURE_ARGS += --extra-cflags=-DSYNO_VIDEOSTATION

# Compiler workaround to enable DTS-HD MA stream decoding
CONFIGURE_ARGS += --extra-cflags=-fno-if-conversion
# Synology default optimization
CONFIGURE_ARGS += --extra-cflags=-O3
# Remove some of the noise while compiling
CONFIGURE_ARGS += --extra-cflags=-Wno-deprecated-declarations

include ../../mk/spksrc.common.mk

OPTIONAL_DEPENDS  = cross/chromaprint-fftw
OPTIONAL_DEPENDS += cross/dav1d
OPTIONAL_DEPENDS += cross/frei0r
OPTIONAL_DEPENDS += cross/libass
OPTIONAL_DEPENDS += cross/libaom
OPTIONAL_DEPENDS += cross/libvpx
OPTIONAL_DEPENDS += cross/libzimg
OPTIONAL_DEPENDS += cross/openh264
OPTIONAL_DEPENDS += cross/svt-av1
OPTIONAL_DEPENDS += cross/libva
OPTIONAL_DEPENDS += cross/libva-utils
OPTIONAL_DEPENDS += cross/intel-vaapi-driver
OPTIONAL_DEPENDS += cross/intel-media-driver
OPTIONAL_DEPENDS += cross/intel-mediasdk
OPTIONAL_DEPENDS += cross/intel-level-zero
OPTIONAL_DEPENDS += cross/intel-graphics-compiler
OPTIONAL_DEPENDS += cross/intel-compute-runtime
OPTIONAL_DEPENDS += cross/ocl-icd
OPTIONAL_DEPENDS += cross/clinfo
OPTIONAL_DEPENDS += cross/twolame
OPTIONAL_DEPENDS += cross/x264
OPTIONAL_DEPENDS += cross/x265
OPTIONAL_DEPENDS += cross/shine

# Define x86asm
ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --x86asmexe=nasm

# Allow ASM on aarch64, disable on all others
else ifneq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --disable-asm
endif

DEPENDS += cross/codec2
CONFIGURE_ARGS += --enable-libcodec2

DEPENDS += cross/libxml2
CONFIGURE_ARGS += --enable-libxml2
CONFIGURE_ARGS += --enable-demuxer=dash

DEPENDS += cross/fontconfig
CONFIGURE_ARGS += --enable-libfontconfig

DEPENDS += cross/freetype
CONFIGURE_ARGS += --enable-libfreetype

DEPENDS += cross/fribidi
CONFIGURE_ARGS += --enable-libfribidi

DEPENDS += cross/openjpeg
CONFIGURE_ARGS += --enable-libopenjpeg

DEPENDS += cross/lame
CONFIGURE_ARGS += --enable-libmp3lame

DEPENDS += cross/libbluray
CONFIGURE_ARGS += --enable-libbluray

DEPENDS += cross/speex
CONFIGURE_ARGS += --enable-libspeex

DEPENDS += cross/flac
DEPENDS += cross/libtheora
CONFIGURE_ARGS += --enable-libtheora

DEPENDS += cross/libcaca
CONFIGURE_ARGS += --enable-libcaca

DEPENDS += cross/libdc1394
CONFIGURE_ARGS += --enable-libdc1394

DEPENDS += cross/libvorbis
CONFIGURE_ARGS += --enable-libvorbis

DEPENDS += cross/libwebp
CONFIGURE_ARGS += --enable-libwebp

DEPENDS += cross/libzmq
CONFIGURE_ARGS += --enable-libzmq

DEPENDS += cross/gnutls
CONFIGURE_ARGS += --enable-gnutls

ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
DEPENDS += cross/openh264
CONFIGURE_ARGS += --enable-libopenh264
endif

DEPENDS += cross/opus
CONFIGURE_ARGS += --enable-libopus

DEPENDS += cross/soxr
CONFIGURE_ARGS += --enable-libsoxr

DEPENDS += cross/opencore-amr
CONFIGURE_ARGS += --enable-libopencore-amrnb --enable-libopencore-amrwb

DEPENDS += cross/librabbitmq
CONFIGURE_ARGS += --enable-librabbitmq

DEPENDS += cross/twolame
CONFIGURE_ARGS += --enable-libtwolame

DEPENDS += cross/zvbi
CONFIGURE_ARGS += --enable-libzvbi

DEPENDS += cross/x264
CONFIGURE_ARGS += --enable-libx264

DEPENDS += cross/x265
CONFIGURE_ARGS += --enable-libx265

DEPENDS += cross/libvpx
CONFIGURE_ARGS += --enable-libvpx

DEPENDS += cross/shine
CONFIGURE_ARGS += --enable-libshine

DEPENDS += cross/chromaprint-fftw
CONFIGURE_ARGS += --enable-chromaprint

DEPENDS += cross/dav1d
CONFIGURE_ARGS += --enable-libdav1d

DEPENDS += cross/librist
CONFIGURE_ARGS += --enable-librist

DEPENDS += cross/libzimg
CONFIGURE_ARGS += --enable-libzimg

DEPENDS += cross/snappy
CONFIGURE_ARGS += --enable-libsnappy

#
# fdk-acc is now considered compatible with (L)GPL.
# It requires --enable-nonfree if you're also using --enable-gpl
#
# https://en.wikipedia.org/wiki/Fraunhofer_FDK_AAC
# It was classified as free by Fedora after a review by the legal department at Red Hat.
# See also: http://wiki.hydrogenaud.io/index.php?title=Fraunhofer_FDK_AAC#FDK_License
#
DEPENDS += cross/fdk-aac
CONFIGURE_ARGS += --enable-libfdk-aac --enable-nonfree

ifeq ($(findstring $(ARCH),alpine comcerto2k monaco $(ARMv8_ARCHS) $(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
DEPENDS += cross/libaom
CONFIGURE_ARGS += --enable-libaom
endif

# Add SVT-AV1 codec to supported ARCH
ifeq ($(findstring $(ARCH),alpine comcerto2k monaco $(ARMv8_ARCHS) $(x64_ARCHS)),$(ARCH))
DEPENDS += cross/svt-av1
CONFIGURE_ARGS += --enable-libsvtav1
endif

##
## ARCH SPECIFIC
##

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm
CONFIGURE_ARGS += --enable-neon
CONFIGURE_ARGS += --enable-thumb
CONFIGURE_ARGS += --enable-lto
CONFIGURE_ARGS += --disable-armv5te
CONFIGURE_ARGS += --disable-armv6
CONFIGURE_ARGS += --disable-armv6t2
CONFIGURE_ARGS += --disable-vfp
ifneq ($(findstring $(ARCH),alpine),$(ARCH))
CONFIGURE_ARGS += --extra-cflags=-DSYNO_ALPINE_NEON
endif
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm64
CONFIGURE_ARGS += --enable-neon
CONFIGURE_ARGS += --enable-thumb
CONFIGURE_ARGS += --enable-lto
endif

ifeq ($(findstring $(ARCH),qoriq),$(ARCH))
CONFIGURE_ARGS += --arch=ppc
CONFIGURE_ARGS += --cpu=e500v2
CONFIGURE_ARGS += --extra-libs=-latomic
CONFIGURE_ARGS += --enable-lto
endif

ifeq ($(findstring $(ARCH),evansport),$(ARCH))
CONFIGURE_ARGS += --arch=x86
CONFIGURE_ARGS += --cpu=atom
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
# Dependencies provided by synocli-videodriver
# If built outside spksrc.videodriver.mk
ifeq ($(strip $(VIDEODRV_PACKAGE)),)
DEPENDS += cross/libva cross/libva-utils
DEPENDS += cross/intel-vaapi-driver
DEPENDS += cross/intel-media-driver cross/intel-mediasdk
DEPENDS += cross/intel-libvpl cross/intel-libvpl-tools
endif
CONFIGURE_ARGS += --arch=x86_64
CONFIGURE_ARGS += --enable-lto
CONFIGURE_ARGS += --enable-libdrm
CONFIGURE_ARGS += --enable-libmfx
CONFIGURE_ARGS += --enable-vaapi
endif

include ../../mk/spksrc.cross-cc.mk

##
## x64  & GCC SPECIFIC
##

# OpenCL acceleration
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
# Newer Intel implementations (oneAPI, level-zero) requires gcc >= 5
ifeq ($(call version_gt, $(TC_GCC), 5),1)
# Dependencies provided by synocli-videodriver
# If built outside spksrc.videodriver.mk
ifeq ($(strip $(VIDEODRV_PACKAGE)),)
DEPENDS += cross/intel-level-zero
DEPENDS += cross/intel-graphics-compiler
DEPENDS += cross/intel-compute-runtime
DEPENDS += cross/ocl-icd
DEPENDS += cross/clinfo
endif
CONFIGURE_ARGS += --enable-opencl
endif
endif

##
## GCC SPECIFIC
##

# libass requires harfbuzz which in turns requires c++ from gcc >= 4.8 (88f6281-6.1 = gcc-4.6.4)
ifeq ($(call version_ge, $(TC_GCC), 4.8),1)
DEPENDS += cross/libass
CONFIGURE_ARGS += --enable-libass
endif

# Newer frei0r requires newer gcc
ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
DEPENDS += cross/frei0r
CONFIGURE_ARGS += --enable-frei0r
endif

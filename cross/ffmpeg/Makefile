PKG_NAME = ffmpeg
PKG_VERS = 4.4.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.ffmpeg.org/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.ffmpeg.org/
COMMENT  = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library
LICENSE  = GPLv2

CONFIGURE_ARGS  = --target-os=linux --cross-prefix=$(TC_PATH)$(TC_PREFIX) --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --extra-cflags="-I$(WORK_DIR)/install$(INSTALL_PREFIX)/include"
CONFIGURE_ARGS += --extra-ldflags="-L$(WORK_DIR)/install$(INSTALL_PREFIX)/lib"
CONFIGURE_ARGS += --extra-libs="-lxml2 -ldl" --pkg-config=/usr/bin/pkg-config --ranlib=$(RANLIB)
CONFIGURE_ARGS += --enable-cross-compile --enable-rpath --enable-pic
CONFIGURE_ARGS += --enable-shared
CONFIGURE_ARGS += --enable-gpl --enable-version3
CONFIGURE_ARGS += --enable-avresample
CONFIGURE_ARGS += --disable-debug
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --disable-doc

# Must match $(SPK_REV) from spk/ffmpeg/Makefil
CONFIGURE_ARGS += --extra-version=$(shell sed -n 's/^SPK_REV = \(.*\)/\1/p' $(WORK_DIR)/../../../spk/ffmpeg/Makefile)

# Enable Synology specific -hls_seek_time option and other optimizations
CONFIGURE_ARGS += --extra-cflags=-DSYNO_VIDEOSTATION

# Compiler workaround to enable DTS-HD MA stream decoding
CONFIGURE_ARGS += --extra-cflags=-fno-if-conversion
# Synology default optimization
CONFIGURE_ARGS += --extra-cflags=-O3
# Remove some of the noise while compiling
CONFIGURE_ARGS += --extra-cflags=-Wno-deprecated-declarations

include ../../mk/spksrc.common.mk

OPTIONAL_DEPENDS  = native/nasm
OPTIONAL_DEPENDS += cross/chromaprint-fftw
OPTIONAL_DEPENDS += cross/dav1d
OPTIONAL_DEPENDS += cross/frei0r
OPTIONAL_DEPENDS += cross/libass
OPTIONAL_DEPENDS += cross/libaom
OPTIONAL_DEPENDS += cross/libvpx
OPTIONAL_DEPENDS += cross/libzimg
OPTIONAL_DEPENDS += cross/svt-av1
OPTIONAL_DEPENDS += cross/svt-hevc
OPTIONAL_DEPENDS += cross/libva
OPTIONAL_DEPENDS += cross/libva-utils
OPTIONAL_DEPENDS += cross/intel-vaapi-driver
OPTIONAL_DEPENDS += cross/intel-media-driver
OPTIONAL_DEPENDS += cross/intel-media-sdk
OPTIONAL_DEPENDS += cross/x264
OPTIONAL_DEPENDS += cross/x265
OPTIONAL_DEPENDS += cross/shine

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

DEPENDS += cross/opus
CONFIGURE_ARGS += --enable-libopus

DEPENDS += cross/soxr
CONFIGURE_ARGS += --enable-libsoxr

DEPENDS += cross/opencore-amr
CONFIGURE_ARGS += --enable-libopencore-amrnb --enable-libopencore-amrwb

DEPENDS += cross/librabbitmq
CONFIGURE_ARGS += --enable-librabbitmq

DEPENDS += cross/zvbi
CONFIGURE_ARGS += --enable-libzvbi

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/x264
CONFIGURE_ARGS += --enable-libx264

DEPENDS += cross/x265
CONFIGURE_ARGS += --enable-libx265

DEPENDS += cross/libvpx
CONFIGURE_ARGS += --enable-libvpx

DEPENDS += cross/shine
CONFIGURE_ARGS += --enable-libshine

# end ifneq $(OLD_PPC_ARCHS)
endif

ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/chromaprint-fftw
CONFIGURE_ARGS += --enable-chromaprint

DEPENDS += cross/dav1d
CONFIGURE_ARGS += --enable-libdav1d

DEPENDS += cross/frei0r
CONFIGURE_ARGS += --enable-frei0r

DEPENDS += cross/librist
CONFIGURE_ARGS += --enable-librist

DEPENDS += cross/libzimg
CONFIGURE_ARGS += --enable-libzimg

# end ifneq $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)
endif

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

ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# Newer libass requires harfbuzz which in turns requires c++ from gcc >= 4.8 (88f6281-6.1 = gcc-4.6.4)
DEPENDS += cross/libass
CONFIGURE_ARGS += --enable-libass
endif
endif

ifeq ($(findstring $(ARCH),alpine comcerto2k monaco $(ARMv8_ARCHS) $(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
DEPENDS += cross/libaom
CONFIGURE_ARGS += --enable-libaom
endif

# Add SVT-AV1 codec to supported ARCH
ifeq ($(findstring $(ARCH),alpine comcerto2k monaco $(ARMv8_ARCHS) $(x64_ARCHS)),$(ARCH))
DEPENDS += cross/svt-av1
CONFIGURE_ARGS += --enable-libsvtav1
endif

# Add SVT-HEVC codec to x64
# Patch for support from: https://raw.githubusercontent.com/OpenVisualCloud/SVT-HEVC/master/ffmpeg_plugin/n4.4-0001-lavc-svt_hevc-add-libsvt-hevc-encoder-wrapper.patch
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
DEPENDS += cross/svt-hevc
CONFIGURE_ARGS += --enable-libsvthevc
endif

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm --disable-neon --disable-asm
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm --enable-neon --enable-thumb --disable-armv6 --disable-armv6t2 --disable-vfp --disable-armv5te --disable-asm
ifneq ($(findstring $(ARCH),alpine),$(ARCH))
CONFIGURE_ARGS += --extra-cflags=-DSYNO_ALPINE_NEON
endif
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm64 --enable-neon --enable-thumb --disable-asm
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --extra-libs=-latomic
CONFIGURE_ARGS += --disable-asm
CONFIGURE_ARGS += --arch=ppc
ifeq ($(findstring $(ARCH),qoriq),$(ARCH))
CONFIGURE_ARGS += --cpu=e500v2
else
CONFIGURE_ARGS += --cpu=e500 --disable-altivec
endif
endif


ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
BUILD_DEPENDS = native/nasm
NASM_PATH = $(realpath $(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin)
ENV += PATH=$(NASM_PATH):$$PATH
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
DEPENDS += cross/libva cross/libva-utils cross/intel-vaapi-driver cross/intel-media-driver cross/intel-media-sdk
CONFIGURE_ARGS += --arch=x86_64 --enable-vaapi --enable-libmfx --enable-libdrm
endif

ifeq ($(findstring $(ARCH),evansport),$(ARCH))
CONFIGURE_ARGS += --arch=x86 --cpu=atom
endif

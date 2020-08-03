PKG_NAME = ffmpeg
PKG_VERS = 4.1.6
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.ffmpeg.org/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/flac
DEPENDS += cross/fontconfig
DEPENDS += cross/freetype
DEPENDS += cross/fribidi
DEPENDS += cross/lame
DEPENDS += cross/gnutls
DEPENDS += cross/libtheora
DEPENDS += cross/libxml2
DEPENDS += cross/opencore-amr
DEPENDS += cross/opus
DEPENDS += cross/soxr
DEPENDS += cross/speex

OPTIONAL_DEPENDS = native/nasm
OPTIONAL_DEPENDS += cross/shine

HOMEPAGE = http://www.ffmpeg.org/
COMMENT  = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library
LICENSE  = GPLv2

NASM_PATH=$(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin

CONFIGURE_ARGS = --target-os=linux --cross-prefix=$(TC_PATH)$(TC_PREFIX) --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --extra-cflags="-I$(WORK_DIR)/install$(INSTALL_PREFIX)/include"
CONFIGURE_ARGS += --extra-ldflags="-L$(WORK_DIR)/install$(INSTALL_PREFIX)/lib"
CONFIGURE_ARGS += --extra-libs="-lxml2 -ldl" --pkg-config=/usr/bin/pkg-config --ranlib=$(RANLIB)
CONFIGURE_ARGS += --enable-cross-compile --enable-rpath --enable-pic
CONFIGURE_ARGS += --enable-shared --enable-gpl --enable-version3
CONFIGURE_ARGS += --disable-debug --disable-doc --disable-static
CONFIGURE_ARGS += --enable-fontconfig --enable-avresample
CONFIGURE_ARGS += --enable-libfreetype
CONFIGURE_ARGS += --enable-libfribidi
CONFIGURE_ARGS += --enable-libmp3lame
CONFIGURE_ARGS += --enable-gnutls
CONFIGURE_ARGS += --enable-libtheora --enable-libvorbis
CONFIGURE_ARGS += --enable-libopencore-amrnb --enable-libopencore-amrwb
CONFIGURE_ARGS += --enable-libopus
CONFIGURE_ARGS += --enable-libsoxr
CONFIGURE_ARGS += --enable-libspeex
CONFIGURE_ARGS += --enable-debug=1

# Compiler workaround to enable DTS-HD MA stream decoding
CONFIGURE_ARGS += --extra-cflags=-fno-if-conversion
# Synology default optimization
CONFIGURE_ARGS += --extra-cflags=-O3
# Remove some of the noise while compiling
CONFIGURE_ARGS += --extra-cflags=-Wno-deprecated-declarations

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=arm --disable-neon --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=arm --enable-neon --enable-thumb --disable-yasm --disable-asm
CONFIGURE_ARGS += --disable-armv6 --disable-armv6t2 --disable-vfp --disable-armv5te
endif

ifeq ($(findstring $(ARCH),$(ARM8_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=arm64 --enable-neon --enable-thumb --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
DEPENDS += native/nasm
ENV += PATH=$(NASM_PATH):$$PATH

ifeq ($(findstring $(ARCH),'evansport'),$(ARCH))
CONFIGURE_ARGS += --arch=x86 --cpu=atom
CONFIGURE_ARGS += --disable-x86asm
CONFIGURE_ARGS += --extra-cflags=-fasm
CONFIGURE_ARGS += --extra-cflags=-std=c99
CONFIGURE_ARGS += --extra-cflags=-pedantic
else
CONFIGURE_ARGS += --arch=i386
endif
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
DEPENDS += native/nasm
ENV += PATH=$(NASM_PATH):$$PATH
CONFIGURE_ARGS += --arch=x86_64
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
DEPENDS += native/nasm
ENV += PATH=$(NASM_PATH):$$PATH
CONFIGURE_ARGS += --arch=ppc

ifeq ($(findstring $(ARCH),qoriq),$(ARCH))
CONFIGURE_ARGS += --disable-asm --cpu=e500v2
endif

# libshine - gcc to old on ppc853x: undefined reference to `__builtin_bswap16'
ifneq ($(findstring $(ARCH),ppc853x),$(ARCH))
DEPENDS += cross/shine
CONFIGURE_ARGS += --enable-libshine
endif
endif

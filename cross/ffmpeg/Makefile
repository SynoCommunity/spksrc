PKG_NAME = ffmpeg
PKG_VERS = 4.2.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.ffmpeg.org/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)



DEPENDS =  cross/libxml2 cross/libiconv cross/fontconfig cross/freetype 
DEPENDS += cross/fribidi cross/xz cross/libvpx cross/fribidi
DEPENDS += cross/opus cross/speex cross/lame cross/dav1d 

ifeq ($(strip $(HANDBRAKE)),)
PATCHES = $(sort $(wildcard patches/00*.patch))
DEPENDS += cross/x265 cross/soxr cross/gnutls cross/flac cross/libsamplerate
DEPENDS += cross/libdvdnav cross/libdvdread cross/harfbuzz native/nasm cross/x264 
DEPENDS += cross/libass cross/libbluray cross/libtheora cross/libvorbis cross/gmp
else
PATCHES = $(sort $(wildcard patches/*.patch))
endif

HOMEPAGE = http://www.ffmpeg.org/
COMMENT  = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library
LICENSE  = GPLv2

NASM_PATH=$(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin

CONFIGURE_ARGS += --target-os=linux --cross-prefix=$(TC_PATH)$(TC_PREFIX) --enable-shared
CONFIGURE_ARGS += --extra-cflags="-I$(WORK_DIR)/install$(INSTALL_PREFIX)/include -DSYNO_VIDEOSTATION -DSYNO_AUDIOSTATION -DSYNO_MEDIASERVER -DSYNO_DSM -fno-if-conversion"
CONFIGURE_ARGS += --enable-cross-compile --enable-rpath --enable-pic --enable-gpl
CONFIGURE_ARGS += --extra-ldflags="-L$(WORK_DIR)/install$(INSTALL_PREFIX)/lib" 
CONFIGURE_ARGS += --extra-libs="-lxml2 -ldl" --pkg-config=/usr/bin/pkg-config --ranlib=$(RANLIB)

#Generic build
ifeq ($(strip $(HANDBRAKE)),)
CONFIGURE_ARGS += --enable-fontconfig --enable-libass --enable-libdav1d
CONFIGURE_ARGS += --enable-libfreetype --enable-libfribidi --enable-libmp3lame
CONFIGURE_ARGS += --enable-libopus --enable-libsoxr --enable-libspeex --enable-gmp
CONFIGURE_ARGS += --enable-libvorbis --enable-libx265 --enable-version3  --enable-avresample
CONFIGURE_ARGS += --enable-libvpx --enable-gnutls  --enable-libx264 --enable-libbluray
CONFIGURE_ARGS += --disable-debug --disable-doc  --enable-libtheora --disable-static
else
#HandBrake required build configuration
CONFIGURE_ARGS += --disable-doc --disable-programs  --disable-avdevice  --disable-muxers 
CONFIGURE_ARGS += --disable-network  --disable-hwaccels  --disable-vdpau --disable-xlib
CONFIGURE_ARGS += --disable-encoders  --enable-libmp3lame  --enable-encoder=aac 
CONFIGURE_ARGS += --enable-encoder=ac3  --enable-encoder=eac3  --enable-encoder=flac  
CONFIGURE_ARGS += --enable-encoder=mpeg2video  --enable-encoder=mpeg4 --enable-static
CONFIGURE_ARGS += --enable-encoder=libmp3lame  --enable-libopus 
CONFIGURE_ARGS += --enable-encoder=libopus  --enable-libspeex 
CONFIGURE_ARGS += --disable-encoder=libspeex  --enable-decoder=libspeex  --enable-libvpx
CONFIGURE_ARGS += --disable-decoder=libvpx_*  --enable-encoder=libvpx_vp8 
CONFIGURE_ARGS += --enable-encoder=libvpx_vp9  --disable-decoder=*_crystalhd 
CONFIGURE_ARGS += --enable-libdav1d  --enable-decoder=libdav1d 
CONFIGURE_ARGS += --enable-muxer=matroska --enable-muxer=webm --enable-muxer=mov 
CONFIGURE_ARGS += --enable-muxer=mp4 --enable-muxer=psp --enable-muxer=ipod
endif

# fdk-acc is not compatible with (L)GPL.
# It can be --enabled for personal use, but not for freely distributed packages.
# compile with variable ENABLE_FDK_AAC=YES if you want to enable it.
ifeq ($(ENABLE_FDK_AAC),YES) 
DEPENDS += cross/fdk-aac
CONFIGURE_ARGS += --enable-libfdk-aac --enable-nonfree --enable-encoder=libfdk_aac
endif


# Compiler workaround to enable DTS-HD MA stream decoding

include ../../mk/spksrc.cross-cc.mk

# Add AV1 codec to supported ARCH
ifeq ($(findstring $(ARCH),alpine comcerto2k monaco $(ARM8_ARCHES) $(x86_ARCHES) $(x64_ARCHES)),$(ARCH))
DEPENDS += cross/libaom
CONFIGURE_ARGS += --enable-libaom
endif


ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=arm --disable-neon --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=arm --enable-neon --enable-thumb --disable-armv6 --disable-armv6t2 --disable-vfp --disable-armv5te --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(ARM8_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=arm64 --enable-neon --enable-thumb --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
DEPENDS += native/nasm
ENV += PATH=$(NASM_PATH):$$PATH
CONFIGURE_ARGS += --arch=i386
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
DEPENDS += native/nasm cross/intel-media-sdk
ENV += PATH=$(NASM_PATH):$$PATH
ENV += LIBVA_DRIVERS_PATH=$(INSTALL_DIR)$(INSTALL_PREFIX)/lib/dri
ENV += LIBVA_DRIVER_NAME=iHD
CONFIGURE_ARGS += --arch=x86_64 --enable-vaapi --enable-libmfx
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
DEPENDS += native/nasm
ENV += PATH=$(NASM_PATH):$$PATH
CONFIGURE_ARGS += --arch=ppc
ifeq ($(findstring $(ARCH),qoriq),$(ARCH))
CONFIGURE_ARGS += --disable-asm --cpu=e500v2
endif
endif

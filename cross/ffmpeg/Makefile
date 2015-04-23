PKG_NAME = ffmpeg
PKG_VERS = 3.1.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.ffmpeg.org/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/fdk-aac cross/flac cross/freetype cross/fribidi cross/lame cross/libass
DEPENDS += cross/libbluray cross/libtheora cross/libvorbis cross/libvpx
DEPENDS += cross/opencore-amr cross/openjpeg cross/openssl cross/opus cross/rtmpdump
DEPENDS += cross/soxr cross/speex cross/vo-amrwbenc cross/x264 cross/x265

HOMEPAGE = http://www.ffmpeg.org/
COMMENT  = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library
LICENSE  = LGPL 2.1

YASM_PATH=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin

CONFIGURE_ARGS = --target-os=linux --cross-prefix=$(TC_PATH)$(TC_PREFIX) --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --extra-cflags="-I$(WORK_DIR)/install$(INSTALL_PREFIX)/include"
CONFIGURE_ARGS += --extra-ldflags="-L$(WORK_DIR)/install$(INSTALL_PREFIX)/lib"
CONFIGURE_ARGS += --extra-libs="-lxml2 -ldl" --pkg-config=/usr/bin/pkg-config --ranlib=$(RANLIB)
CONFIGURE_ARGS += --enable-cross-compile --enable-rpath --enable-pic
CONFIGURE_ARGS += --enable-shared --enable-optimizations --enable-pthreads
CONFIGURE_ARGS += --enable-gpl --enable-version3 --enable-nonfree
CONFIGURE_ARGS += --enable-fontconfig --enable-libass --enable-libbluray
CONFIGURE_ARGS += --enable-libfdk-aac --enable-libfreetype --enable-libfribidi --enable-libmp3lame
CONFIGURE_ARGS += --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg
CONFIGURE_ARGS += --enable-libopus --enable-librtmp --enable-libsoxr --enable-libspeex
CONFIGURE_ARGS += --enable-libtheora --enable-libvo-amrwbenc --enable-libvorbis
CONFIGURE_ARGS += --enable-libvpx --enable-libx264 --enable-libx265 --enable-openssl
CONFIGURE_ARGS += --disable-debug --disable-doc --disable-htmlpages --disable-manpages
CONFIGURE_ARGS += --disable-podpages --disable-static --disable-txtpages

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=arm --disable-neon --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=arm --disable-neon --disable-armv6 --disable-armv6t2 --disable-vfp --disable-armv5te --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
DEPENDS += native/yasm
ENV += PATH=$(YASM_PATH):$$PATH
CONFIGURE_ARGS += --arch=i386 --enable-thumb
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
DEPENDS += native/yasm
ENV += PATH=$(YASM_PATH):$$PATH
CONFIGURE_ARGS += --arch=x86_64 --enable-thumb
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
DEPENDS += native/yasm
ENV += PATH=$(YASM_PATH):$$PATH
CONFIGURE_ARGS += --arch=ppc
endif


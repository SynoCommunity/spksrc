PKG_NAME = ffmpeg
PKG_VERS = 3.0.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.ffmpeg.org/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/fdk-aac cross/flac cross/freetype cross/lame cross/libass cross/libbluray
DEPENDS += cross/libopus cross/libtheora cross/libvorbis cross/libvpx cross/openjpeg cross/openssl
DEPENDS += cross/rtmpdump cross/speex cross/x264 cross/x265 cross/opencore-amr

HOMEPAGE = http://www.ffmpeg.org/
COMMENT  = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library
LICENSE  = LGPL 2.1

CONFIGURE_ARGS = --target-os=linux --cross-prefix=$(TC_PATH)$(TC_PREFIX) --prefix=$(INSTALL_PREFIX) --extra-cflags="-I$(WORK_DIR)/install$(INSTALL_PREFIX)/include"
CONFIGURE_ARGS += --extra-ldflags="-L$(WORK_DIR)/install$(INSTALL_PREFIX)/lib" --extra-libs="-lxml2 -ldl" --pkg-config=/usr/bin/pkg-config --ranlib=$(RANLIB)
CONFIGURE_ARGS += --enable-gpl --enable-version3 --enable-nonfree --enable-cross-compile --enable-rpath --enable-pic --enable-pthreads
CONFIGURE_ARGS += --enable-libx264 --enable-libx265 --enable-libmp3lame --enable-libfdk-aac --enable-libspeex --enable-openssl --enable-libvorbis
CONFIGURE_ARGS += --enable-gpl --enable-nonfree  --enable-fontconfig --enable-libfreetype
CONFIGURE_ARGS += --enable-libass --enable-libbluray --enable-libopenjpeg --enable-libopus --enable-libtheora --enable-librtmp
CONFIGURE_ARGS += --enable-libopencore-amrnb --enable-libopencore-amrwb
CONFIGURE_ARGS += --enable-libvpx --disable-static --enable-shared --enable-pic
CONFIGURE_ARGS += --disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages  --disable-debug

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=arm --disable-neon --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=arm --disable-neon --disable-armv6 --disable-armv6t2 --disable-vfp --disable-armv5te --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=i386 --enable-thumb
DEPENDS += native/yasm
ENV += PATH=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/:$$PATH
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=x86_64 --enable-thumb
DEPENDS += native/yasm
ENV += PATH=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/:$$PATH
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=ppc
DEPENDS += native/yasm
ENV += PATH=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin/:$$PATH
endif

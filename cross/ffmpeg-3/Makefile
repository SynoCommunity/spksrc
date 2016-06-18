PKG_NAME = ffmpeg-3
PKG_VERS = 3.0.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = ffmpeg-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.ffmpeg.org/releases/
PKG_DIR = ffmpeg-$(PKG_VERS)

DEPENDS = cross/x264-git cross/lame cross/fdk-aac cross/xvid

HOMEPAGE = http://www.ffmpeg.org/
COMMENT  = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library
LICENSE  =

REQUIRED_DSM = 5.1

ifeq ($(findstring $(ARCH),armada370 armadaxp armada375 alpine comcerto2k 88f6281 monaco),$(ARCH))
MYARCH = arm
endif
ifeq ($(findstring $(ARCH),evansport),$(ARCH))
MYARCH = i386
endif
ifeq ($(findstring $(ARCH),avoton braswell bromolow cedarview x86 x64),$(ARCH))
MYARCH = x86_64
endif
ifeq ($(MYARCH),)
$(error Unsupported ARCH $(ARCH))
endif


CONFIGURE_ARGS = --disable-yasm --disable-doc --enable-gpl --enable-libx264 --enable-libmp3lame --enable-libfdk-aac --enable-libxvid --enable-nonfree --enable-cross-compile --arch=$(MYARCH) --target-os=linux --cross-prefix=$(TC_PATH)$(TC_PREFIX) --prefix=$(INSTALL_PREFIX) --extra-cflags="-I$(WORK_DIR)/install$(INSTALL_PREFIX)/include" --extra-ldflags="-L$(WORK_DIR)/install$(INSTALL_PREFIX)/lib" --extra-libs=-ldl

include ../../mk/spksrc.cross-cc.mk

PKG_NAME = ffmpeg
PKG_VERS = 3.3.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.ffmpeg.org/releases/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/x264 cross/lame

HOMEPAGE = http://www.ffmpeg.org/
COMMENT  = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library
LICENSE  = FFmpeg codebase is mainly LGPL-licensed with optional components licensed under GPL. Please refer to the LICENSE file for detailed information.

YASM_PATH=$(WORK_DIR)/../../../native/yasm/work-native/install/usr/local/bin

CONFIGURE_ARGS = --enable-gpl --enable-libx264 --enable-libmp3lame --enable-nonfree --enable-cross-compile --enable-optimizations --enable-pic --enable-version3 --enable-avresample --disable-swscale-alpha --arch=$(ARCH) --target-os=linux --cross-prefix=$(TC_PATH)$(TC_PREFIX) --prefix=$(INSTALL_PREFIX) --extra-cflags="-I$(WORK_DIR)/install$(INSTALL_PREFIX)/include" --extra-ldflags="-L$(WORK_DIR)/install$(INSTALL_PREFIX)/lib" --extra-libs=-ldl --enable-shared --disable-encoder=zmbv

ADDITIONAL_CFLAGS = -fPIC

ifneq ($(filter $(ARCH), 88f5281 88f6281 armadaxp armada370 armada375 armada38x comcerto2k),)
	CONFIGURE_ARGS += --disable-asm --disable-yasm --disable-neon --arch=arm
else
	ifneq ($(filter $(ARCH), ppc853x ppc854x),)
		DEPENDS += native/yasm
		ENV += PATH=$(YASM_PATH):$$PATH
		CONFIGURE_ARGS += --disable-asm --disable-yasm --arch=ppc
	else
		ifneq ($(filter $(ARCH), qoriq),)
			CONFIGURE_ARGS += --disable-asm --disable-yasm --arch=ppc64
		else
			DEPENDS += native/yasm
			ENV += PATH=$(YASM_PATH):$$PATH
		endif
	endif
endif

include ../../mk/spksrc.cross-cc.mk

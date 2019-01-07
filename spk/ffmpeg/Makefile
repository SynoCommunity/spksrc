SPK_NAME = ffmpeg
SPK_VERS = 4.1
SPK_REV = 11
SPK_ICON = src/ffmpeg.png
CHANGELOG = "1. Update ffmpeg to 4.1 (latest release) 2. Update ffmpeg dependencies to latest release and fix associated compilation issues 3. Fix HDR10Plus support in x265 4. Fix x265 support for ppc platforms with recent releases"

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = cytec
DESCRIPTION = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library.
DISPLAY_NAME = ffmpeg
STARTABLE = no

HOMEPAGE = http://www.ffmpeg.org/
LICENSE  = GPLv3

PRE_COPY_TARGET = ffmpeg_custom_pre_copy

include ../../mk/spksrc.spk.mk

.PHONY: ffmpeg_custom_pre_copy
ffmpeg_custom_pre_copy: $(INSTALL_PLIST)
	# Remove libhdr10plus reference from PLIST if it isn't available on the platform (e.g. 88f6281)
	test -f $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/libhdr10plus.so || sed -i -e '/:lib\/libhdr10plus.so/d' $(INSTALL_PLIST)

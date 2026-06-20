SPK_NAME = demometa-ffmpeg
SPK_VERS = 1.0.0
SPK_REV = 1
SPK_ICON = src/demometa-ffmpeg.png

# Include common.mk first to get ARCH definitions
include ../../mk/spksrc.common.mk

# Declare the ffmpeg meta package: SPK_BASE_TEMPLATE accumulates and exports
# its pkgconfig dir so the cross/ test probe resolves ffmpeg libs. (ffmpeg7
# itself pulls synocli-videodriver, which the meta wrapper also picks up.)
FFMPEG_PACKAGE = ffmpeg7

# cmake probe that pkg-config-resolves libavcodec/libavformat from the meta
DEPENDS = cross/demometa-ffmpeg-cmake

MAINTAINER = SynoCommunity
DESCRIPTION = Meta cross-dependency test package: validates that ffmpeg meta libraries (libavcodec, libavformat) are shared to cross/ dependencies via the ordered PKG_CONFIG_LIBDIR.
DISPLAY_NAME = Demo Meta FFmpeg
LICENSE = MIT
STARTABLE = no

include ../../mk/spksrc.spk-meta.mk

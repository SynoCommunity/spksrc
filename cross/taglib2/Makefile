PKG_NAME = taglib
PKG_VERS = 2.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://taglib.org/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/utfcpp

# requires "CMAKE_CXX_STANDARD 17"
REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k
REQUIRED_MIN_SRM = 1.3

HOMEPAGE = https://taglib.org/
COMMENT  = TagLib is a library for reading and editing the meta-data of several popular audio formats. Currently it supports both ID3v1 and ID3v2 for MP3 files, Ogg Vorbis comments and ID3 tags and Vorbis comments in FLAC, MPC, Speex, WavPack, TrueAudio, WAV, AIFF, MP4 and ASF files.
LICENSE  = LGPLv2.1

GNU_CONFIGURE = 1
CMAKE_ARGS += -DBUILD_SHARED_LIBS=ON
CMAKE_ARGS += -DBUILD_TESTING=OFF

include ../../mk/spksrc.cross-cmake.mk

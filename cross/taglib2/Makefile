PKG_NAME = taglib
PKG_VERS = 2.1.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://taglib.org/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/utfcpp

# CMakeLists.txt sets CMAKE_CXX_STANDARD 17 without CMAKE_CXX_STANDARD_REQUIRED,
# so cmake silently drops the flag and the C++17 code is a syntax error instead:
#   taglib/mpeg/mpegheader.cpp:184: expected ')' before ';' token
# (an if with initialiser, if(const int layerBits = ...; layerBits == 1))
MIN_GCC_VERSION = 7

HOMEPAGE = https://taglib.org/
COMMENT  = TagLib is a library for reading and editing the meta-data of several popular audio formats. Currently it supports both ID3v1 and ID3v2 for MP3 files, Ogg Vorbis comments and ID3 tags and Vorbis comments in FLAC, MPC, Speex, WavPack, TrueAudio, WAV, AIFF, MP4 and ASF files.
LICENSE  = LGPLv2.1

GNU_CONFIGURE = 1
CONFIGURE_ARGS += -DBUILD_SHARED_LIBS=ON
CONFIGURE_ARGS += -DBUILD_TESTING=OFF

include ../../mk/spksrc.cross-cmake.mk

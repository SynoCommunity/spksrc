PKG_NAME = chromaprint
PKG_VERS = 1.5.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/acoustid/chromaprint/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

HOMEPAGE = http://acoustid.org/chromaprint
COMMENT  = Chromaprint is the core component of the AcoustID project. It\'s a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
LICENSE  = LGPL2.1+

DEPENDS = cross/fftw cross/chromaprint-ffmpeg

include ../../mk/spksrc.cross-cmake.mk

# chromaprint specific for proper build
CMAKE_ARGS += -DBUILD_TOOLS=ON
CMAKE_ARGS += -DBUILD_SHARED_LIBS=ON
#CMAKE_ARGS += -DBUILD_SHARED_LIBS=OFF
CMAKE_ARGS += -DFFT_LIB=fftw3f
CMAKE_ARGS += -DCMAKE_CXX_FLAGS=-Wno-deprecated-declarations

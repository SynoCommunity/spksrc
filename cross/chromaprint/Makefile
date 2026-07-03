PKG_NAME = chromaprint
PKG_VERS = 1.6.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/acoustid/chromaprint/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

#PKG_GIT_HASH = aa67c95b9e486884a6d3ee8b0c91207d8c2b0551
#PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
#PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
#PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

HOMEPAGE = https://acoustid.org/chromaprint
COMMENT  = Chromaprint is the core component of the AcoustID project. It\'s a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
LICENSE  = LGPL2.1+

OPTIONAL_DEPENDS = cross/ffmpeg7

# ffmpeg7 requires c11 support
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

CMAKE_ARGS += -DBUILD_TOOLS=ON
CMAKE_ARGS += -DBUILD_TESTS=OFF
CMAKE_ARGS += -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations"

ifneq ($(wildcard $(FFMPEG_STAGING_INSTALL_PREFIX)),)
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH=$(FFMPEG_INSTALL_PREFIX)/lib
else
DEPENDS = cross/ffmpeg7
CMAKE_RPATH =
endif

include ../../mk/spksrc.cross-cmake.mk

PKG_NAME = chromaprint
PKG_VERS = 1.5.2
PKG_EXT = tar.gz
PKG_GIT_HASH = aa67c95b9e486884a6d3ee8b0c91207d8c2b0551
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/acoustid/chromaprint/archive
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

HOMEPAGE = https://acoustid.org/chromaprint
COMMENT  = Chromaprint is the core component of the AcoustID project. It\'s a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
LICENSE  = LGPL2.1+

OPTIONAL_DEPENDS = cross/ffmpeg$(FFMPEG_VERSION)

# compiler too old
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

ifneq ($(wildcard $(FFMPEG_DIR)),)
CMAKE_RPATH = /var/packages/ffmpeg$(subst 4,,$(FFMPEG_VERSION))/target/lib
else
DEPENDS = cross/ffmpeg$(FFMPEG_VERSION)
CMAKE_RPATH =
endif

CMAKE_BUILD_DIR = $(WORK_DIR)/$(PKG_DIR)
CMAKE_USE_TOOLCHAIN_FILE = OFF

include ../../mk/spksrc.cross-cmake.mk

CMAKE_ARGS += -DBUILD_TOOLS=ON
CMAKE_ARGS += -DBUILD_TESTS=OFF
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH=$(CMAKE_RPATH)
CMAKE_ARGS += -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations"

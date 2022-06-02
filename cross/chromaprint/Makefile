PKG_NAME = chromaprint
PKG_VERS = 1.5.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/acoustid/chromaprint/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://acoustid.org/chromaprint
COMMENT  = Chromaprint is the core component of the AcoustID project. It\'s a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
LICENSE  = LGPL2.1+

OPTIONAL_DEPENDS = cross/ffmpeg

# compiler too old
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

ifneq ($(wildcard $(FFMPEG_DIR)),)
CMAKE_RPATH = /var/packages/ffmpeg/target/lib
else
DEPENDS = cross/ffmpeg
CMAKE_RPATH =
endif

CMAKE_BUILD_DIR = $(WORK_DIR)/$(PKG_DIR)
CMAKE_USE_TOOLCHAIN_FILE = OFF

include ../../mk/spksrc.cross-cmake.mk

CMAKE_ARGS += -DBUILD_TOOLS=ON
CMAKE_ARGS += -DBUILD_TESTS=OFF
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH=$(CMAKE_RPATH)
CMAKE_ARGS += -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations"

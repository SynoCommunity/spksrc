PKG_NAME = chromaprint
PKG_VERS = 1.5.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/acoustid/chromaprint/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://acoustid.org/chromaprint
COMMENT  = Chromaprint is the core component of the AcoustID project. It\'s a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
LICENSE  = LGPL2.1+

DEPENDS = cross/fftw

# compiler too old
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

CMAKE_BUILD_DIR = $(WORK_DIR)/$(PKG_DIR)

include ../../mk/spksrc.cross-cmake.mk

CMAKE_ARGS += -DBUILD_TOOLS=OFF
CMAKE_ARGS += -DBUILD_TESTS=OFF

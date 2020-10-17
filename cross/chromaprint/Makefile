PKG_NAME = chromaprint
PKG_VERS = 1.5.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/acoustid/chromaprint/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

HOMEPAGE = http://acoustid.org/chromaprint
COMMENT  = Chromaprint is the core component of the AcoustID project. It\'s a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
LICENSE  = LGPL2.1+

UNSUPPORTED_ARCHS = $(ARM5_ARCHES) powerpc ppc824x ppc853x ppc854x

ifneq ($(wildcard $(FFMPEG_DIR)),)
CMAKE_RPATH = /var/packages/ffmpeg/target/lib
else
DEPENDS = cross/ffmpeg
CMAKE_RPATH =
endif

CMAKE_BUILD_DIR = $(WORK_DIR)/$(PKG_DIR)

include ../../mk/spksrc.cross-cmake.mk

CMAKE_ARGS += -DBUILD_TOOLS=ON
CMAKE_ARGS += -DCMAKE_INSTALL_RPATH=$(CMAKE_RPATH)

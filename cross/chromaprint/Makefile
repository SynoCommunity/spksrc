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

OPTIONAL_DEPENDS = cross/ffmpeg8

# ffmpeg-8 no longer support 88f6281 (armv5) and hi3535 (armv7l)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)

CONFIGURE_ARGS += -DBUILD_TOOLS=ON
CONFIGURE_ARGS += -DBUILD_TESTS=OFF
CONFIGURE_ARGS += -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations"

include ../../mk/spksrc.cross-cmake.mk

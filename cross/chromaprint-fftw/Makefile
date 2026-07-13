# Distinct PKG_NAME from cross/chromaprint (same upstream, fftw FFT backend):
# avoids a meta status-cookie collision that made a consumer skip building its
# own cross/chromaprint. Download/extract still use the upstream "chromaprint".
PKG_NAME = chromaprint-fftw
PKG_VERS = 1.6.0
PKG_EXT = tar.gz
PKG_DIST_NAME = chromaprint-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/acoustid/chromaprint/releases/download/v$(PKG_VERS)
PKG_DIR = chromaprint-$(PKG_VERS)

HOMEPAGE = https://acoustid.org/chromaprint
COMMENT  = Chromaprint is the core component of the AcoustID project. It\'s a client-side library that implements a custom algorithm for extracting fingerprints from any audio source.
LICENSE  = LGPL2.1+

DEPENDS = cross/fftw

# compiler too old
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

BUILD_DIR = $(WORK_DIR)/$(PKG_DIR)

include ../../mk/spksrc.cross-cmake.mk

CONFIGURE_ARGS += -DBUILD_TOOLS=OFF
CONFIGURE_ARGS += -DBUILD_TESTS=OFF

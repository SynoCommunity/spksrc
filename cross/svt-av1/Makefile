PKG_NAME = SVT-AV1
PKG_VERS = 0.8.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/OpenVisualCloud/SVT-AV1/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
# Set an appropriate filename as release files on github doesn't
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

DEPENDS =

HOMEPAGE = https://github.com/OpenVisualCloud/SVT-AV1
COMMENT  = The Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder) is an AV1-compliant encoder/decoder library core.
LICENSE  = SPDX short identifier: BSD-2-Clause-Patent

UNSUPPORTED_ARCHS = $(ARM5_ARCHES) $(PPC_ARCHES)

CMAKE_USE_NASM = 1

include ../../mk/spksrc.cross-cmake.mk

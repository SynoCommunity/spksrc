PKG_NAME = SVT-AV1
PKG_VERS = 0.8.7
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v$(PKG_VERS)/
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/OpenVisualCloud/SVT-AV1
COMMENT  = The Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder) is an AV1-compliant encoder/decoder library core.
LICENSE  = SPDX short identifier: BSD-2-Clause-Patent

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS)

CMAKE_USE_NASM = 1

include ../../mk/spksrc.cross-cmake.mk

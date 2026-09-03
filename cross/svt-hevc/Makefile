PKG_NAME = SVT-HEVC
PKG_VERS = 1.5.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/OpenVisualCloud/SVT-HEVC/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/OpenVisualCloud/SVT-HEVC
COMMENT  = Scalable Video Technology (SVT) is a software-based video coding technology that is highly optimized for Intel® Xeon® processors allowing to spread video encoding processing across multiple processors to achieve a real advantage of processing efficiency.
LICENSE  = SPDX short identifier: BSD-2-Clause-Patent

# SVT-HEVC is only supported on x86_64 Intel platforms
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

# 64-bit only (its configure refuses 32-bit) and needs gcc >= 4.9
REQUIRE_64BIT = 1
MIN_GCC_VERSION = 4.9

CMAKE_USE_NASM = 1

include ../../mk/spksrc.cross-cmake.mk

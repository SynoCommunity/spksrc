PKG_NAME = vvenc
PKG_VERS = 1.14.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/fraunhoferhhi/vvenc/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.hhi.fraunhofer.de/en/departments/vca/technologies-and-solutions/h266-vvc.html
COMMENT  = VVenC, the Fraunhofer Versatile Video Encoder, is a fast and efficient software H.266/VVC encoder implementation
LICENSE  = BSD-3-Clause-Clear license

# Needs gcc >= 7.5: needs C++17, i.e. gcc 7 or newer.
MIN_GCC_VERSION = 7.5

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
CONFIGURE_ARGS += -DVVENC_ENABLE_ARM_SIMD=FALSE
endif

include ../../mk/spksrc.cross-cmake.mk

PKG_NAME = libvmaf
PKG_VERS = 3.2.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Netflix/vmaf/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = vmaf-$(PKG_VERS)

HOMEPAGE = https://github.com/Netflix/vmaf
COMMENT  = VMAF is an Emmy-winning perceptual video quality assessment algorithm developed by Netflix.
LICENSE  = SPDX short identifier: BSD-2-Clause-Patent

# Needs gcc >= 7.5: needs C++17, i.e. gcc 7 or newer.
MIN_GCC_VERSION = 7.5

MESON_BASE_DIR = $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME)

CONFIGURE_ARGS += -Denable_tests=false
CONFIGURE_ARGS += -Denable_docs=false

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CONFIGURE_ARGS += -Denable_avx512=false
CONFIGURE_ARGS += -Denable_asm=false
endif

include ../../mk/spksrc.cross-meson.mk

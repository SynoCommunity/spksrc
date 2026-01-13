PKG_NAME = sps-alsa-explore
PKG_VERS = 1.1
PKG_EXT = tar.gz
# git hash from February 17th 2023
PKG_GIT_HASH = defb2ab6ccda8c6bb0506b4c3f0d145ddc0d0bf0
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mikebrady/sps-alsa-explore/archive
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

DEPENDS = cross/alsa-lib

HOMEPAGE = https://github.com/mikebrady/sps-alsa-explore
COMMENT  = A tool to scan ALSA devices for use by Shairport Sync.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = sps-alsa-explore_pre_configure

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# take clock_gettime from librt
ADDITIONAL_LDFLAGS = -lrt
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: sps-alsa-explore_pre_configure
sps-alsa-explore_pre_configure:
	@$(RUN) autoreconf -fi

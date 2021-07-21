PKG_NAME = Lidarr
PKG_VERS = 0.8.0.2042
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME).develop.$(PKG_VERS).linux-core-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/lidarr/$(PKG_NAME)/releases/download/v$(PKG_VERS)
PKG_DIR = Lidarr

DEPENDS =

UNSUPPORTED_ARCHS = $(i686_ARCHS) $(ARMv7L_ARCHS) $(ARMv5_ARCHS) $(PPC_ARCHS)

HOMEPAGE = https://lidarr.audio/
COMMENT  = Lidarr is a music collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new tracks from your favorite artists and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
LICENSE  = GPLv3

INSTALL_TARGET = lidarr_install

# use digests with multiple files
PKG_DIST_ARCH_LIST = x64 arm arm64

include ../../mk/spksrc.archs.mk
PKG_DIST_ARCH = x64
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm64
endif

include ../../mk/spksrc.install-resources.mk

.PHONY: lidarr_install
lidarr_install:
	rm -rf $(WORK_DIR)/$(PKG_DIR)/Lidarr.Update
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin

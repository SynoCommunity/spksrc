PKG_NAME = Lidarr
PKG_VERS = 0.8.0.2042
PKG_EXT = tar.gz

include ../../mk/spksrc.archs.mk
PKG_ARCH = x64
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_ARCH = arm
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_ARCH = arm64
endif
PKG_DIST_NAME = $(PKG_NAME).develop.$(PKG_VERS).linux-core-$(PKG_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/lidarr/$(PKG_NAME)/releases/download/v$(PKG_VERS)
PKG_DIR = Lidarr

HOMEPAGE = https://lidarr.audio/
COMMENT  = Lidarr is a music collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new tracks from your favorite artists and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.
LICENSE  = GPLv3

PRE_CHECKSUM_TARGET = lidarr_prechecksum
POST_CHECKSUM_TARGET = lidarr_postchecksum
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = lidarr_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: lidarr_prechecksum
lidarr_prechecksum:
	cp digests_dir/$(PKG_ARCH) digests

.PHONY: lidarr_postchecksum
lidarr_postchecksum:
	rm digests

.PHONY: lidarr_install
lidarr_install:
	rm -rf $(WORK_DIR)/$(PKG_DIR)/Lidarr.Update
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin

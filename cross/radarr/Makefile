include ../../mk/spksrc.archs.mk

PKG_NAME = Radarr
PKG_VERS = 3.0.2.4552
PKG_EXT = tar.gz

PKG_ARCH = x64
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_ARCH = arm
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_ARCH = arm64
endif

PKG_DIST_NAME = $(PKG_NAME).master.$(PKG_VERS).linux-core-$(PKG_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Radarr/Radarr/releases/download/v$(PKG_VERS)
PKG_DIR = Radarr

HOMEPAGE = https://radarr.video/
COMMENT  = Radarr is a movie collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new movies and will interface with clients and indexers to grab, sort, and rename them. It can also be configured to automatically upgrade the quality of existing files in the library when a better quality format becomes available.
LICENSE  = GNU GPL v3

PRE_CHECKSUM_TARGET = radarr_prechecksum
POST_CHECKSUM_TARGET = radarr_postchecksum
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = radarr_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: radarr_prechecksum
radarr_prechecksum:
	cp digests_dir/$(PKG_ARCH) digests

.PHONY: radarr_postchecksum
radarr_postchecksum:
	rm digests

.PHONY: radarr_install
radarr_install:
	rm -rf $(WORK_DIR)/$(PKG_DIR)/Radarr.Update
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin

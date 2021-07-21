PKG_NAME = Radarr
PKG_VERS = 3.0.2.4552
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME).master.$(PKG_VERS).linux-core-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Radarr/Radarr/releases/download/v$(PKG_VERS)
PKG_DIR = Radarr

DEPENDS =

UNSUPPORTED_ARCHS = $(i686_ARCHS) $(ARMv7L_ARCHS) $(ARMv5_ARCHS) $(PPC_ARCHS)

HOMEPAGE = https://radarr.video/
COMMENT  = Radarr is a movie collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new movies and will interface with clients and indexers to grab, sort, and rename them. It can also be configured to automatically upgrade the quality of existing files in the library when a better quality format becomes available.
LICENSE  = GPLv3

INSTALL_TARGET = radarr_install

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

.PHONY: radarr_install
radarr_install:
	rm -rf $(WORK_DIR)/$(PKG_DIR)/Radarr.Update
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin

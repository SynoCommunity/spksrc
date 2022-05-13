PKG_NAME = Prowlarr
PKG_VERS = 0.2.0.1678
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME).develop.$(PKG_VERS).linux-core-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Prowlarr/Prowlarr/releases/download/v$(PKG_VERS)
PKG_DIR = Prowlarr

DEPENDS = cross/curl cross/sqlite

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(i686_ARCHS)

HOMEPAGE = https://prowlarr.com/
COMMENT  = Prowlarr is an indexer manager/proxy built on the popular arr .net/reactjs base stack to integrate with your various PVR apps. Prowlarr supports management of both Torrent Trackers and Usenet Indexers. It integrates seamlessly with Lidarr, Mylar3, Radarr, Readarr, and Sonarr offering complete management of your indexers with no per app Indexer setup required (we do it all).
LICENSE  = GPLv3

INSTALL_TARGET = prowlarr_install

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

.PHONY: prowlarr
prowlarr_install:
	rm -rf $(WORK_DIR)/$(PKG_DIR)/Prowlarr.Update
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin

PKG_NAME = Sonarr
PKG_VERS = 4.0.10.2544
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME).main.$(PKG_VERS).linux-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Sonarr/Sonarr/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE = https://sonarr.tv
COMMENT  = Sonarr is a PVR for newsgroup users. It can monitor multiple RSS feeds for new episodes of your favourite shows and will grab, sorts and rename them. It can also be configured to automatically upgrade the quality of files already downloaded if a better quality format becomes available.
LICENSE  = GNU GPL v3

INSTALL_TARGET = sonarr_install

# use digests with multiple files
PKG_DIST_ARCH_LIST = x64 arm arm64

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = x64
else ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm64
endif

include ../../mk/spksrc.install-resources.mk

.PHONY: sonarr_install
sonarr_install:
	rm -rf $(WORK_DIR)/$(PKG_DIR)/Sonarr.Update
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin

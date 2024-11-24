PKG_NAME = Readarr
PKG_VERS = 0.4.1.2648
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME).develop.$(PKG_VERS).linux-core-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Readarr/Readarr/releases/download/v$(PKG_VERS)
PKG_DIR = Readarr

DEPENDS =

HOMEPAGE = https://readarr.com/
COMMENT  = Readarr is an eBook collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new books and will interface with clients and indexers to grab, sort, and rename them. It can also be configured to automatically upgrade the quality of existing files in the library when a better quality format becomes available.
LICENSE  = GPLv3

INSTALL_TARGET = readarr_install

# use digests with multiple files
PKG_DIST_ARCH_LIST = x86 x64 arm arm64

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
PKG_DIST_ARCH = x86
else ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
PKG_DIST_ARCH = x64
else ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = arm64
endif

include ../../mk/spksrc.install-resources.mk

.PHONY: readarr_install
readarr_install:
	rm -rf $(WORK_DIR)/$(PKG_DIR)/Readarr.Update
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin

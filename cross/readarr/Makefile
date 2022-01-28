PKG_NAME = Readarr
PKG_VERS = 0.1.0.1225
PKG_EXT = tar.gz
PKG_DIST_NAME = updatefile?os=linux\&runtime=netcore\&arch=$(PKG_DIST_ARCH)
PKG_DIST_FILE = $(PKG_NAME).develop.$(PKG_VERS).linux-core-$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = http://readarr.servarr.com/v1/update/nightly
PKG_DIR = Readarr

DEPENDS = cross/curl cross/sqlite

UNSUPPORTED_ARCHS = $(i686_ARCHS) $(ARMv7L_ARCHS) $(ARMv5_ARCHS) $(PPC_ARCHS)

HOMEPAGE = https://readarr.com/
COMMENT  = Readarr is an eBook collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new books and will interface with clients and indexers to grab, sort, and rename them. It can also be configured to automatically upgrade the quality of existing files in the library when a better quality format becomes available.
LICENSE  = GPLv3

INSTALL_TARGET = readarr_install

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

.PHONY: readarr_install
readarr_install:
	rm -rf $(WORK_DIR)/$(PKG_DIR)/Readarr.Update
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share/$(PKG_DIR)/bin

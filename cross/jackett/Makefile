PKG_NAME = Jackett
PKG_VERS = 0.22.534
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME).Binaries.Linux$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Jackett/Jackett/releases/download/v$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).Binaries.Linux$(PKG_DIST_ARCH).$(PKG_EXT)
PKG_DIR = Jackett

DEPENDS =

HOMEPAGE = https://github.com/Jackett/Jackett
COMMENT  = Jackett works as a proxy server: it translates queries from apps into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software. Jackett is a single repository of maintained indexer scraping & translation logic - removing the burden from other apps.
LICENSE  = GPLv2

INSTALL_TARGET = jackett_install

# use digests with multiple files
PKG_DIST_ARCH_LIST = AMDx64 ARM32 ARM64

include ../../mk/spksrc.archs.mk
PKG_DIST_ARCH = AMDx64
ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
PKG_DIST_ARCH = ARM32
else ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
PKG_DIST_ARCH = ARM64
endif

include ../../mk/spksrc.install-resources.mk

.PHONY: jackett_install
jackett_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share
	tar -cf - -C $(WORK_DIR)/$(PKG_DIR) . | tar -xf - -C $(STAGING_INSTALL_PREFIX)/share

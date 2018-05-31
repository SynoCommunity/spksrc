ARCH ?= wdx64
TCVERSION ?= 6.1
PKG_NAME = wdx64
PKG_BRANCH = 15152
PKG_ARCH = $(PKG_NAME)
PKG_EXT = tar.gz
PKG_DIST_NAME = linux-4.1.13.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/WDCommunity/wdpksrc/releases/download/kernel-tc-v0.01/
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_DIST_NAME)
PKG_EXTRACT = linux-4.1.13
SYNO_CONFIG = synoconfigs/$(ARCH)
BASE_ARCH = x86

HOMEPAGE = http://www.wd.com/

include ../../mk/spksrc.kernel-modules.mk

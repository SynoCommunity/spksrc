ARCH ?= cedarview
TCVERSION ?= 6.0
PKG_NAME = cedarview
PKG_BRANCH = 7274
PKG_ARCH = linux-3.10.x
PKG_EXT = txz
PKG_DIST_NAME = $(PKG_ARCH).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/dsgpl/Synology%20NAS%20GPL%20Source/$(PKG_BRANCH)branch
PKG_EXTRACT = $(PKG_ARCH)
SYNO_CONFIG = synoconfigs/$(PKG_NAME)
BASE_ARCH = x86

HOMEPAGE = http://www.synology.com/

include ../../mk/spksrc.kernel-modules.mk

menuconfig:
	$(RUN) $(MAKE) menuconfig

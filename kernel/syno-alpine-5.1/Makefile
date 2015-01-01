ARCH ?= alpine
TCVERSION ?= 5.1
PKG_NAME = synogpl
PKG_BRANCH = 5004
PKG_ARCH = $(ARCH)
PKG_EXT = tbz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_BRANCH)-$(PKG_ARCH).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/dsgpl/Synology%20NAS%20GPL%20Source/$(PKG_BRANCH)branch
PKG_EXTRACT = source/linux-3.x
SYNO_CONFIG = synoconfigs/$(ARCH)
BASE_ARCH = arm

HOMEPAGE = http://www.synology.com/

include ../../mk/spksrc.kernel-modules.mk

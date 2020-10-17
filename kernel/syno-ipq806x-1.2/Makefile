ARCH ?= ipq806x
TCVERSION ?= 1.2
PKG_NAME = synogpl
PKG_BRANCH = 7742
PKG_ARCH = $(ARCH)
PKG_EXT = tbz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_BRANCH)-$(PKG_ARCH).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/dsgpl/files/Synology%20Router%20GPL%20Source/$(PKG_BRANCH)branch
PKG_EXTRACT = source/linux-4.4.x
SYNO_CONFIG = synoconfigs/$(ARCH)
BASE_ARCH = arm

HOMEPAGE = http://www.synology.com/

include ../../mk/spksrc.kernel-modules.mk

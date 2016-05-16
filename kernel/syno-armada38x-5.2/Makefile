ARCH ?= armada38x
TCVERSION ?= 5.2
PKG_NAME = armada38x
PKG_BRANCH = 5644
PKG_ARCH = $(PKG_NAME)
PKG_EXT = txz
PKG_DIST_NAME = $(PKG_ARCH)-source.$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/dsgpl/Synology%20NAS%20GPL%20Source/$(PKG_BRANCH)branch
PKG_EXTRACT = source/linux-3.10.x-bsp
SYNO_CONFIG = synoconfigs/$(ARCH)
BASE_ARCH = arm

HOMEPAGE = http://www.synology.com/

include ../../mk/spksrc.kernel-modules.mk

ARCH ?= braswell
TCVERSION ?= 5.2
PKG_NAME = braswell
PKG_BRANCH = 5644
PKG_ARCH = $(PKG_NAME)
PKG_EXT = txz
PKG_DIST_NAME = $(PKG_ARCH)-source.$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/dsgpl/Synology%20NAS%20GPL%20Source/$(PKG_BRANCH)branch
PKG_EXTRACT = source/linux-3.10.x
SYNO_CONFIG = synoconfigs/x86_64
BASE_ARCH = x86

HOMEPAGE = http://www.synology.com/

include ../../mk/spksrc.kernel-modules.mk

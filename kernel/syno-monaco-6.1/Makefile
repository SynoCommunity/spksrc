ARCH ?= monaco
TCVERSION ?= 6.1
PKG_NAME = monaco
PKG_BRANCH = 15152
PKG_ARCH = $(PKG_NAME)
PKG_EXT = txz
PKG_DIST_NAME = linux-3.10.x-bsp.$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/dsgpl/Synology%20NAS%20GPL%20Source/$(PKG_BRANCH)branch/$(PKG_ARCH)-source
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_DIST_NAME)
PKG_EXTRACT = linux-3.10.x-bsp
SYNO_CONFIG = synoconfigs/$(ARCH)
BASE_ARCH = arm

HOMEPAGE = http://www.synology.com/

include ../../mk/spksrc.kernel-modules.mk

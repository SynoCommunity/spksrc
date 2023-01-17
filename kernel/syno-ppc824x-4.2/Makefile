ARCH ?= ppc824x
TCVERSION ?= 4.2
PKG_NAME = synogpl
PKG_BRANCH = 2636
PKG_ARCH = 824x
PKG_EXT = tbz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_BRANCH)-$(PKG_ARCH).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/dsgpl/Synology%20NAS%20GPL%20Source/$(PKG_BRANCH)branch
PKG_EXTRACT = source/linux-2.6.24
SYNO_CONFIG = synoconfigs/$(ARCH)
BASE_ARCH = ppc

KERNEL_ENV = $(TC_ENV) LDFLAGS=""

HOMEPAGE = http://www.synology.com/

include ../../mk/spksrc.kernel-modules.mk

ARCH ?= armada375
TCVERSION ?= 5.2
PKG_NAME = armada375
PKG_BRANCH = 5565
PKG_ARCH = $(PKG_NAME)
PKG_EXT = txz
PKG_DIST_NAME = $(PKG_ARCH)-source.$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/dsgpl/Synology%20NAS%20GPL%20Source/$(PKG_BRANCH)branch
PKG_EXTRACT = source/linux-3.x
SYNO_CONFIG = synoconfigs/$(PKG_ARCH)
BASE_ARCH = arm

HOMEPAGE = http://www.synology.com/

PRE_COMPILE_TARGET = myPreCompile

include ../../mk/spksrc.kernel-modules.mk

PHONY: myPreCompile
myPreCompile:
	cd $(KERNEL_DIR)/arch/arm/ && rm -rf plat-armada && ln -s plat-armada-v2 plat-armada

ARCH ?= ppc853x
TCVERSION ?= 5.2
PKG_NAME = 853x
PKG_BRANCH = 5565
PKG_ARCH = $(PKG_NAME)
PKG_EXT = txz
PKG_DIST_NAME = $(PKG_ARCH)-source.$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/dsgpl/Synology%20NAS%20GPL%20Source/$(PKG_BRANCH)branch
PKG_EXTRACT = source/linux-2.6.32
SYNO_CONFIG = synoconfigs/ppc8533
BASE_ARCH = powerpc

HOMEPAGE = http://www.synology.com/

PRE_COMPILE_TARGET = kernel_ppc_premake

include ../../mk/spksrc.kernel-modules.mk

.PHONY: kernel_ppc_premake

kernel_ppc_premake:
	$(RUN) $(MAKE) LDFLAGS="" arch/powerpc/lib/crtsavres.o

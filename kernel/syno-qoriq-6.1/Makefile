ARCH ?= qoriq
TCVERSION ?= 6.1
PKG_NAME = qoriq
PKG_BRANCH = 15152
PKG_ARCH = $(PKG_NAME)
PKG_EXT = txz
PKG_DIST_NAME = linux-2.6.32.$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/dsgpl/Synology%20NAS%20GPL%20Source/$(PKG_BRANCH)branch/$(PKG_ARCH)-source
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_DIST_NAME)
PKG_EXTRACT = linux-2.6.32
SYNO_CONFIG = synoconfigs/ppcQorIQ
BASE_ARCH = powerpc

HOMEPAGE = http://www.synology.com/

PRE_COMPILE_TARGET = kernel_ppc_premake

include ../../mk/spksrc.kernel-modules.mk

.PHONY: kernel_ppc_premake

kernel_ppc_premake:
	$(RUN) $(MAKE) LDFLAGS="" arch/powerpc/lib/crtsavres.o

ARCH ?= powerpc
PKG_NAME = synogpl
PKG_BRANCH = 2198
PKG_ARCH = ppc
PKG_EXT = tbz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_BRANCH)-$(PKG_ARCH).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/dsgpl/Synology%20NAS%20GPL%20Source/$(PKG_BRANCH)branch
PKG_EXTRACT = source/uclinux2422/linux-2.4.x
SYNO_CONFIG = powerpc-config
BASE_ARCH = ppc

HOMEPAGE = http://www.synology.com/

POST_EXTRACT_TARGET = copy_powerpc_makefile
PRE_COMPILE_TARGET = kernel_make_oldconfig

include ../../mk/spksrc.kernel-modules.mk

.PHONY: copy_powerpc_makefile kernel_make_oldconfig

copy_powerpc_makefile:
	cp $(KERNEL_DIR)/Makefile.powerpc $(KERNEL_DIR)/Makefile

kernel_make_oldconfig:
	$(RUN) $(MAKE) oldconfig
	$(RUN) $(MAKE) dep

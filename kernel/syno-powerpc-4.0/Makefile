KERNEL_ARCH = powerpc
KERNEL_VERS = 4.0
KERNEL_BUILD = 2198
KERNEL_EXT = tbz
KERNEL_DIST = linux-2.4.x
KERNEL_DIST_NAME = synogpl-$(KERNEL_BUILD)-ppc.$(KERNEL_EXT)
KERNEL_PREFIX = source/uclinux2422/$(KERNEL_DIST)
KERNEL_STRIP = 2
KERNEL_CONFIG = powerpc-config
KERNEL_BASE_ARCH = ppc

POST_EXTRACT_TARGET = copy_powerpc_makefile

include ../../mk/spksrc.kernel.mk

copy_powerpc_makefile:
	cp $(WORK_DIR)/$(KERNEL_DIST)/Makefile.powerpc $(WORK_DIR)/$(KERNEL_DIST)/Makefile

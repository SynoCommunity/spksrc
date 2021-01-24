KERNEL_ARCH = powerpc
KERNEL_VERS = 4.0
KERNEL_BUILD = 2198
KERNEL_EXT = tbz
KERNEL_DIST = source/uclinux2422/linux-2.4.x
KERNEL_CONFIG = powerpc-config
KERNEL_BASE_ARCH = ppc

POST_EXTRACT_TARGET = copy_powerpc_makefile
PRE_COMPILE_TARGET = kernel_make_oldconfig

include ../../mk/spksrc.kernel.mk

.PHONY: copy_powerpc_makefile kernel_make_oldconfig

copy_powerpc_makefile:
	cp $(KERNEL_DIR)/Makefile.powerpc $(KERNEL_DIR)/Makefile

kernel_make_oldconfig:
	$(RUN) $(MAKE) oldconfig
	$(RUN) $(MAKE) dep

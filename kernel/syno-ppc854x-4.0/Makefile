KERNEL_ARCH = ppc854x
KERNEL_VERS = 4.0
KERNEL_BUILD = 2198
KERNEL_EXT = tbz
KERNEL_DIST = linux-2.6.32
KERNEL_DIST_NAME = synogpl-$(KERNEL_BUILD)-854x.$(KERNEL_EXT)
KERNEL_BASE_ARCH = powerpc

PRE_COMPILE_TARGET = kernel_ppc_premake

include ../../mk/spksrc.kernel.mk

.PHONY: kernel_ppc_premake

kernel_ppc_premake:
	$(RUN) $(MAKE) LDFLAGS="" arch/powerpc/lib/crtsavres.o

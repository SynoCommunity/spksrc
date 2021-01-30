KERNEL_ARCH = qoriq
KERNEL_VERS = 5.2
KERNEL_BUILD = 5565
KERNEL_DIST = linux-2.6.32
KERNEL_CONFIG = synoconfigs/ppcQorIQ
KERNEL_BASE_ARCH = powerpc

PRE_COMPILE_TARGET = kernel_ppc_premake

include ../../mk/spksrc.kernel.mk

.PHONY: kernel_ppc_premake

kernel_ppc_premake:
	$(RUN) $(MAKE) LDFLAGS="" arch/powerpc/lib/crtsavres.o

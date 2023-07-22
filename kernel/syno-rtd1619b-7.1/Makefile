KERNEL_ARCH = rtd1619b
KERNEL_VERS = 7.1
KERNEL_BUILD = 42962
KERNEL_DIST = linux-5.10.x
KERNEL_BASE_ARCH = arm64
KERNEL_URL_VERSION = 7.1.1

PRE_KERNEL_CONFIGURE_TARGET = install-config_kernel_pre_compile

include ../../mk/spksrc.kernel.mk

PHONY: install-config_kernel_pre_compile
install-config_kernel_pre_compile:
	$(RUN) install -d synoconfigs
	$(RUN) install -m 644 ../../../../kernel/syno-$(KERNEL_ARCH)-$(KERNEL_VERS)/$(KERNEL_ARCH).config synoconfigs/$(KERNEL_ARCH)

### TEMPORARY download test (kernel.org family) - demo, to be archived.
PKG_NAME = demodl-kernel
PKG_DIST_NAME = util-linux-2.41.4.tar.xz
PKG_DIST_SITE = https://www.kernel.org/pub/linux/utils/util-linux/v2.41

CHECKSUM_TARGET = nop
EXTRACT_TARGET = nop
PATCH_TARGET = nop
INSTALL_TARGET = demodl_install

include ../../mk/spksrc.common.mk

include ../../mk/spksrc.cross-install.mk

.PHONY: demodl_install
demodl_install:
	@mkdir -p $(STAGING_INSTALL_PREFIX)/share/demodl
	@echo "$(PKG_NAME): download + install reached - OK" > $(STAGING_INSTALL_PREFIX)/share/demodl/$(PKG_NAME).ok
